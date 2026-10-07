#!/usr/bin/env python3
"""Inspect remote-tracking main refs for governed skill adoption."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import subprocess
from pathlib import Path

import jsonschema
import yaml


def git(path: Path, *args: str) -> tuple[bool, str]:
    result = subprocess.run(
        ["git", "-C", str(path), *args],
        text=True, encoding="utf-8", errors="replace",
        capture_output=True, check=False,
    )
    return result.returncode == 0, result.stdout.strip() if result.returncode == 0 else result.stderr.strip()


def inspect(identity: dict, authority: str, checkout_root: Path, schema: dict,
            skill_root: Path) -> dict:
    row = {
        "id": identity["id"],
        "authority": authority,
        "path": identity["path"],
        "remote": identity["remote"],
        "declaredStatus": identity.get("status", "active"),
        "state": "unverified",
        "revision": None,
        "manifestBlob": None,
        "skillPackRevision": None,
        "enabledSkills": [],
        "findings": [],
    }
    if row["declaredStatus"] == "planned":
        row["state"] = "planned"
        return row
    path = checkout_root / identity["path"]
    if not path.exists():
        row["state"] = "checkout_missing"
        row["findings"].append("Local checkout is absent; remote repository state was not inferred.")
        return row
    remote_ok, remote_url = git(path, "remote", "get-url", "origin")
    if not remote_ok or remote_url.rstrip("/").removesuffix(".git").casefold() != row["remote"].rstrip("/").removesuffix(".git").casefold():
        row["state"] = "remote_mismatch"
        row["findings"].append("Checkout origin does not match the catalog remote.")
        return row
    ok, revision = git(path, "rev-parse", "origin/main")
    if not ok:
        row["state"] = "main_ref_missing"
        row["findings"].append("origin/main is unavailable in this checkout.")
        return row
    row["revision"] = revision
    ok, manifest_text = git(path, "show", "origin/main:.psdc/agent-skills.yaml")
    if not ok:
        row["state"] = "manifest_missing"
        row["findings"].append("No skill manifest exists at the inspected origin/main revision.")
        return row
    ok, blob = git(path, "rev-parse", "origin/main:.psdc/agent-skills.yaml")
    row["manifestBlob"] = blob if ok else None
    try:
        manifest = yaml.safe_load(manifest_text)
        jsonschema.validate(manifest, schema)
    except (yaml.YAMLError, jsonschema.ValidationError) as exc:
        row["state"] = "invalid"
        row["findings"].append(f"Manifest schema failed: {exc}")
        return row
    row["skillPackRevision"] = manifest["skillPack"]["revision"]
    row["enabledSkills"] = manifest["enabledSkills"]
    if manifest["repository"]["id"] != row["id"] or manifest["repository"]["authority"] != authority:
        row["findings"].append("Manifest repository identity or authority differs from the catalog.")
    pack_ok, _ = git(skill_root, "cat-file", "-e", f"{row['skillPackRevision']}^{{commit}}")
    if not pack_ok:
        row["findings"].append("Pinned skill-pack commit is not available in the local skill checkout.")
    else:
        registry_ok, registry_text = git(
            skill_root, "show",
            f"{row['skillPackRevision']}:{manifest['skillPack']['registry']}",
        )
        policy_ok, _ = git(
            skill_root, "cat-file", "-e",
            f"{row['skillPackRevision']}:{manifest['skillPack']['policy']}",
        )
        if not registry_ok or not policy_ok:
            row["findings"].append("Pinned registry or authority policy is absent at the declared skill-pack revision.")
        else:
            pinned_registry = yaml.safe_load(registry_text)
            enabled = {
                item["id"] for item in pinned_registry["skills"]
                if item["mode"] in {"adapted", "enabled"}
            }
            forbidden = {item["id"] for item in pinned_registry["prohibited"] + pinned_registry["deferred"]}
            if any(skill not in enabled or skill in forbidden for skill in row["enabledSkills"]):
                row["findings"].append("Manifest enables a skill outside its pinned registry.")
    for entrypoint in manifest["entrypoints"]:
        if Path(entrypoint).is_absolute() or ".." in Path(entrypoint).parts:
            row["findings"].append(f"Unsafe entrypoint: {entrypoint}")
            continue
        entry_ok, _ = git(path, "cat-file", "-e", f"origin/main:{entrypoint}")
        if not entry_ok:
            row["findings"].append(f"Entrypoint missing at inspected revision: {entrypoint}")
    for steering in ("AGENTS.md", "CLAUDE.md"):
        steering_ok, steering_text = git(path, "show", f"origin/main:{steering}")
        if not steering_ok:
            row["findings"].append(f"{steering} missing at inspected revision.")
        elif steering == "AGENTS.md" and row["id"] != "psdc-agent-skills" and ".psdc/agent-skills.yaml" not in steering_text:
            row["findings"].append("AGENTS.md does not point to the manifest.")
        elif steering == "CLAUDE.md" and "AGENTS.md" not in steering_text:
            row["findings"].append("CLAUDE.md does not point to AGENTS.md.")
    row["state"] = "validated" if not row["findings"] else "invalid"
    return row


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--workspace-root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--checkout-root", type=Path, default=Path(r"C:\Users\jredj\dev\psdc"))
    parser.add_argument("--output-root", type=Path)
    args = parser.parse_args()
    workspace_root = args.workspace_root.resolve()
    checkout_root = args.checkout_root.resolve()
    output_root = (args.output_root or workspace_root).resolve()
    catalog = yaml.safe_load((workspace_root / "repos.yaml").read_text(encoding="utf-8"))
    skill_root = checkout_root / "common/psdc-agent-skills"
    schema_ok, schema_revision = git(skill_root, "rev-parse", "origin/main")
    if not schema_ok:
        raise SystemExit("Cannot resolve the common skill-pack origin/main revision.")
    schema_ok, schema_text = git(skill_root, "show", "origin/main:schemas/consumer-manifest.schema.json")
    if not schema_ok:
        raise SystemExit("Cannot read the consumer schema from common skill-pack origin/main.")
    schema = json.loads(schema_text)
    rows = []
    for entry in catalog["repositories"]:
        rows.append(inspect(entry["repository"], "common", checkout_root, schema, skill_root))
        for overlay in entry["institutionOverlays"]:
            rows.append(inspect(overlay, "institution", checkout_root, schema, skill_root))
    report = {
        "schemaVersion": 1,
        "observedAt": dt.datetime.now(dt.timezone.utc).isoformat(),
        "source": "local origin/main remote-tracking refs; fetch before regeneration",
        "auditorSchemaRevision": schema_revision if schema_ok else None,
        "rows": rows,
    }
    json_path = output_root / "registry/generated-skill-adoption.json"
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8", newline="\n")
    lines = [
        "# Ecosystem Skill Adoption",
        "",
        "> Generated from `repos.yaml`, the common skill registry, consumer schema,",
        "> and each checkout's local `origin/main` ref. Fetch before regeneration.",
        "> This is structural routing evidence, not proof an agent obeyed a skill.",
        "",
        f"Observed: {report['observedAt']}",
        "",
        "| Repository | Authority | State | Main revision | Pinned skill pack | Findings |",
        "|---|---|---|---|---|---|",
    ]
    for row in rows:
        finding = "; ".join(row["findings"]) or "none"
        lines.append(
            f"| {row['id']} | {row['authority']} | {row['state']} | "
            f"{(row['revision'] or '—')[:8]} | {(row['skillPackRevision'] or '—')[:8]} | {finding} |"
        )
    lines.extend([
        "",
        f"Validated: {sum(row['state'] == 'validated' for row in rows)}; "
        f"planned: {sum(row['state'] == 'planned' for row in rows)}; "
        f"other: {sum(row['state'] not in {'validated', 'planned'} for row in rows)}.",
        "",
        "See [[docs/skill-application/Ecosystem-Skill-Review-2026-10-07]] for the",
        "human assessment and next evidence needed.",
    ])
    md_path = output_root / "Maps/Generated/Ecosystem Skill Adoption.md"
    md_path.parent.mkdir(parents=True, exist_ok=True)
    md_path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    print(f"Inspected {len(rows)} catalog identities; wrote {json_path} and {md_path}")
    return 0 if all(row["state"] in {"validated", "planned"} for row in rows) else 1


if __name__ == "__main__":
    raise SystemExit(main())
