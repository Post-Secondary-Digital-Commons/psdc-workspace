#!/usr/bin/env python3
"""Generate PSDC Obsidian command-center views from governed registries."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import re
import subprocess
from pathlib import Path
from urllib.parse import urlparse

import jsonschema
import yaml


EVIDENCE_ORDER = [
    "proposed", "documented", "contracted", "structurally_validated",
    "implemented", "deployed", "production_proven",
]


def run(command: list[str], cwd: Path | None = None) -> tuple[int, str]:
    completed = subprocess.run(
        command, cwd=cwd, text=True, encoding="utf-8", errors="replace",
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False,
    )
    return completed.returncode, completed.stdout.strip()


def git(path: Path, *args: str) -> str | None:
    if not (path / ".git").exists() and not (path / ".git").is_file():
        return None
    code, output = run(["git", "-C", str(path), *args])
    return output if code == 0 else None


def github_prs(owner: str, name: str, online: bool) -> list[dict]:
    if not online:
        return []
    code, output = run([
        "gh", "pr", "list", "--repo", f"{owner}/{name}", "--state", "open",
        "--json", "number,title,url",
    ])
    if code != 0:
        return [{"error": output or "GitHub query failed"}]
    return json.loads(output)


def markdown_count(path: Path) -> int:
    return sum(1 for p in path.rglob("*.md") if ".git" not in p.parts) if path.exists() else 0


def stub_count(path: Path) -> int:
    if not path.exists():
        return 0
    pattern = re.compile(r"(?im)^\s*>?\s*status\s*:\s*stub\b")
    count = 0
    for item in path.rglob("*.md"):
        if ".git" in item.parts:
            continue
        try:
            if pattern.search(item.read_text(encoding="utf-8", errors="replace")):
                count += 1
        except OSError:
            pass
    return count


def inspect_checkout(item: dict, checkout_root: Path, online: bool, overlay: bool = False) -> dict:
    identity = item if overlay else item["repository"]
    path = checkout_root / identity["path"]
    exists = path.exists()
    revision = git(path, "rev-parse", "HEAD") if exists else None
    branch = git(path, "branch", "--show-current") if exists else None
    dirty_text = git(path, "status", "--porcelain") if exists else None
    tag = git(path, "describe", "--tags", "--abbrev=0") if exists else None
    sync = "not-applicable"
    if overlay and exists:
        counts = git(path, "rev-list", "--left-right", "--count", "upstream/main...HEAD")
        if counts and len(counts.split()) == 2:
            behind, ahead = counts.split()
            sync = f"behind {behind}, ahead {ahead}"
        else:
            sync = "upstream/main not available"
    declared_status = identity.get("status", "active")
    prs = [] if declared_status == "planned" else github_prs(identity["owner"], identity["id"], online)
    checkout_status = "planned" if declared_status == "planned" else ("present" if exists else "missing")
    return {
        "id": identity["id"],
        "owner": identity["owner"],
        "path": identity["path"],
        "exists": exists,
        "revision": revision,
        "shortRevision": revision[:8] if revision else "missing",
        "branch": branch or "unknown",
        "dirty": bool(dirty_text),
        "tag": tag,
        "openPullRequests": prs,
        "markdownFiles": markdown_count(path),
        "stubs": stub_count(path),
        "declaredEvidence": item.get("evidence", {}) if not overlay else {},
        "role": identity.get("role", "institution_overlay"),
        "lifecycle": identity.get("lifecycle", "institution-specific"),
        "authority": identity.get("authority", "institution"),
        "planned": identity.get("status") == "planned",
        "declaredStatus": declared_status,
        "checkoutStatus": checkout_status,
        "sync": sync,
    }


def validate_catalog_semantics(catalog: dict) -> None:
    ids = [entry["repository"]["id"] for entry in catalog["repositories"]]
    if len(ids) != len(set(ids)):
        raise ValueError("Repository ids must be unique.")
    known = set(ids)
    providers: dict[str, list[str]] = {}
    for entry in catalog["repositories"]:
        repository_id = entry["repository"]["id"]
        for dependency in entry["dependencies"]["required"] + entry["dependencies"]["optional"]:
            if dependency not in known:
                raise ValueError(f"{repository_id} references unknown dependency {dependency}.")
        for interface in entry["interfaces"]["provides"]:
            providers.setdefault(interface, []).append(repository_id)
    external = {item["id"] for item in catalog.get("externalInterfaces", [])}
    for entry in catalog["repositories"]:
        repository_id = entry["repository"]["id"]
        for interface in entry["interfaces"]["consumes"]:
            owners = providers.get(interface, [])
            if not owners and interface not in external:
                raise ValueError(f"{repository_id} consumes {interface}, which has no provider or external boundary.")
            if len(owners) > 1:
                raise ValueError(f"{interface} has multiple common providers: {', '.join(owners)}.")
    required = {
        entry["repository"]["id"]: entry["dependencies"]["required"]
        for entry in catalog["repositories"]
    }
    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(repository_id: str) -> None:
        if repository_id in visiting:
            raise ValueError(f"Required dependency cycle reaches {repository_id}.")
        if repository_id in visited:
            return
        visiting.add(repository_id)
        for dependency in required[repository_id]:
            visit(dependency)
        visiting.remove(repository_id)
        visited.add(repository_id)

    for repository_id in required:
        visit(repository_id)


def audit_evidence_artifacts(evidence: dict, catalog: dict, workspace_root: Path,
                             checkout_root: Path) -> list[dict]:
    """Verify immutable artifact bytes and scope; do not claim tests were rerun."""
    identities = {
        (item["owner"].casefold(), item["id"].casefold()): checkout_root / item["path"]
        for entry in catalog["repositories"]
        for item in [entry["repository"], *entry["institutionOverlays"]]
    }
    rows = []
    for record in evidence["evidence"]:
        artifact = record["artifact"]
        revision = record["revision"]
        row = {"claimId": record["claimId"], "revision": revision, "status": "unverified", "reason": None}
        parsed = urlparse(artifact)
        if parsed.scheme:
            parts = parsed.path.strip("/").split("/")
            if parsed.scheme != "https" or parsed.netloc.casefold() != "github.com" or len(parts) < 5 or parts[2] != "blob" or parts[3] != revision:
                row["reason"] = "Artifact URL is not an immutable GitHub blob at the claimed revision."
                rows.append(row)
                continue
            repository = identities.get((parts[0].casefold(), parts[1].casefold()))
            relative = "/".join(parts[4:])
        else:
            repository = workspace_root
            relative = artifact.replace("\\", "/")
        if not repository or not repository.exists() or not relative or relative.startswith("/") or ".." in Path(relative).parts:
            row["reason"] = "Artifact repository or relative path is absent or unsafe."
            rows.append(row)
            continue
        result = subprocess.run(["git", "-C", str(repository), "show", f"{revision}:{relative}"],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
        if result.returncode != 0:
            row["reason"] = "Artifact does not resolve at the claimed commit in the local checkout."
        elif "sha256:" + hashlib.sha256(result.stdout).hexdigest() != record["artifactDigest"]:
            row["reason"] = "Artifact bytes do not match the registered SHA-256 digest."
        else:
            row["status"] = "digest_verified"
        rows.append(row)
    return rows


def md_table(headers: list[str], rows: list[list[str]]) -> str:
    lines = ["| " + " | ".join(headers) + " |", "|" + "|".join(["---"] * len(headers)) + "|"]
    lines.extend("| " + " | ".join(str(cell).replace("|", "\\|") for cell in row) + " |" for row in rows)
    return "\n".join(lines)


def render_command_center(snapshot: dict, catalog: dict, evidence: dict) -> str:
    common = snapshot["commonRepositories"]
    overlays = snapshot["institutionOverlays"]
    open_prs = sum(len([p for p in repo["openPullRequests"] if "number" in p]) for repo in common + overlays)
    missing = sum(1 for repo in common + overlays if not repo["exists"] and not repo["planned"])
    stubs = sum(repo["stubs"] for repo in common + overlays)
    product_test_records = [record for record in evidence["evidence"]
                            if record["state"] == "structurally_validated" and record["scope"].startswith("common-psdc-")]
    verified_evidence = sum(row["status"] == "digest_verified" for row in snapshot["evidenceAudit"])
    query_errors = [
        f"{repo['id']}: {item['error']}"
        for repo in common + overlays
        for item in repo["openPullRequests"]
        if "error" in item
    ]
    rows = []
    for repo in common + overlays:
        prs = [p for p in repo["openPullRequests"] if "number" in p]
        evidence_posture = repo["declaredEvidence"]
        rows.append([
            repo["id"], repo["authority"], repo["checkoutStatus"], repo["lifecycle"],
            repo["shortRevision"] + (" dirty" if repo["dirty"] else ""),
            str(len(prs)) if repo["openPullRequests"] else ("0" if snapshot["online"] else "not queried"),
            str(repo["markdownFiles"]), str(repo["stubs"]), repo["sync"],
            evidence_posture.get("contracts", "overlay-specific"),
            evidence_posture.get("implementation", "overlay-specific"),
        ])
    baseline = next((r["tag"] for r in common if r["id"] == "psdc-architecture"), None) or "no local tag"
    return f"""---
tags: [generated, command-center, evidence]
generated: true
generatedAt: {snapshot['generatedAt']}
---

# Workspace Command Center

> Generated projection. Source authority remains in the Decision Register, ADRs,
> contracts, repository documents, and institution overlays. Regenerate with
> `python scripts/Build-WorkspaceCommandCenter.py --checkout-root C:\\Users\\jredj\\dev\\psdc --online`.

## Evidence boundary

`Proposed != Documented != Contracted != Structurally validated != Implemented != Deployed != Production proven`

## Current snapshot

- Common architecture baseline tag: **{baseline}**
- Catalog entries: **{len(catalog['repositories'])} common / {len(overlays)} institution overlays**
- Open pull requests observed: **{open_prs if snapshot['online'] else 'not queried'}**
- Online observation errors: **{len(query_errors)}**; inspect `registry/generated-workspace-status.json` for bounded error details.
- Missing expected checkouts: **{missing}**
- Markdown documents observed: **{sum(r['markdownFiles'] for r in common + overlays)}**
- Documents explicitly marked as stubs: **{stubs}**
- Broken-link count: **not assessed by this generator**; run `scripts/Test-Documentation.ps1` and ingest its report as evidence.
- Semantic-clone count: **not asserted by this generator**; use the architecture semantic audit.
- Security findings: **not assessed by this generator**; use pinned OpenSSF Scorecard and repository security scans.
- Test status: **command-center schemas and catalog semantics passed during generation**; **{len(product_test_records)}** commit-bound common product test record(s) are indexed. Artifact digests resolve for **{verified_evidence}/{len(snapshot['evidenceAudit'])}** evidence records. This generator does not rerun their test commands or prove runtime behavior.
- Accepted decisions: **the Decision Register reports the project-controlled defaults accepted**; external approvals and measured deployment evidence remain separate gates.
- Next recommended vertical slice: **reconcile workload classification fields and the remaining lease/settlement authority blockers, then prepare the bounded H-006 D2 admission packet**. The indexed product evidence is structural, not implementation.

## Repository state

{md_table(['Repository', 'Authority', 'Checkout status', 'Lifecycle', 'Revision', 'Open PRs', 'Docs', 'Stubs', 'Overlay sync', 'Contracts', 'Implementation'], rows)}

## Readiness interpretation

The catalog's `evidence` fields are declared posture and are not automatically
promoted by file counts. The evidence registry contains bounded claims and their
limitations. A missing checkout means local status is unknown, not that the
remote repository is absent. A dirty checkout is non-reproducible: its displayed
commit identifies only `HEAD`, and uncommitted content is not accepted evidence.

## Generated views

- [[Maps/Generated/Repository and Dependency Catalog]]
- [[Maps/Generated/Authority Map]]
- [[Maps/Generated/Evidence and Readiness Registry]]
- [[Maps/Generated/Contract Explorer]]
- [[Maps/Generated/Ecosystem Skill Adoption]]
"""


def render_catalog(catalog: dict) -> str:
    rows = []
    edges = []
    for entry in catalog["repositories"]:
        repo = entry["repository"]
        rows.append([repo["id"], repo["role"], repo["lifecycle"], ", ".join(entry["dependencies"]["required"]) or "none", ", ".join(entry["interfaces"]["provides"]) or "none"])
        for dependency in entry["dependencies"]["required"]:
            edges.append(f"    {repo['id'].replace('-', '_')} --> {dependency.replace('-', '_')}")
    return """# Repository and Dependency Catalog

> Generated from `repos.yaml`; edit the catalog, not this view.

""" + md_table(["Repository", "Role", "Lifecycle", "Required dependencies", "Provides"], rows) + "\n\n## Required dependency graph\n\n```mermaid\ngraph TD\n" + "\n".join(edges) + "\n```\n"


def render_authority(authority: dict) -> str:
    lines = ["# Authority Map", "", "> Generated from `registry/authority.yaml`.", "", "```text"]
    for index, item in enumerate(authority["precedence"], start=1):
        lines.append(f"{index}. {item['id']} -> {', '.join(item['governs'])}")
    lines.extend(["```", "", f"Conflict policy: **{authority['conflictPolicy']}**", ""])
    return "\n".join(lines)


def render_evidence(evidence: dict, audit: list[dict]) -> str:
    by_id = {row["claimId"]: row for row in audit}
    rows = []
    for record in evidence["evidence"]:
        rows.append([record["claimId"], record["scope"], record["state"], by_id[record["claimId"]]["status"], record["artifact"], record["artifactDigest"], record["revision"], record["verification"]])
    return "# Evidence and Readiness Registry\n\n> Generated from `registry/evidence.yaml`. Evidence states are ordered: " + " -> ".join(EVIDENCE_ORDER) + ". `digest_verified` proves only that the artifact bytes match the named Git revision; it does not rerun the listed verification.\n\n" + md_table(["Claim", "Scope", "State", "Artifact digest check", "Artifact", "SHA-256", "Revision", "Verification claim"], rows) + "\n"


def render_contract_explorer(checkout_root: Path) -> str:
    architecture = checkout_root / "common" / "psdc-architecture"
    groups = {"JSON Schema": [], "OpenAPI": [], "AsyncAPI": [], "State machines": [], "Fixtures": [], "Validators": []}
    if architecture.exists():
        contracts = architecture / "contracts"
        for path in contracts.rglob("*") if contracts.exists() else []:
            if not path.is_file():
                continue
            relative = path.relative_to(checkout_root).as_posix()
            name = path.name.lower()
            if "fixture" in relative.lower(): groups["Fixtures"].append(relative)
            elif "state-machine" in relative.lower() or name.endswith(".machine.json"): groups["State machines"].append(relative)
            elif "openapi" in name: groups["OpenAPI"].append(relative)
            elif "asyncapi" in name: groups["AsyncAPI"].append(relative)
            elif name.endswith("schema.json"): groups["JSON Schema"].append(relative)
            elif "valid" in name or path.suffix.lower() in {".ps1", ".py"}: groups["Validators"].append(relative)
    lines = ["# Contract Explorer", "", "> Generated inventory. Presence is not proof of semantic correctness or runtime conformance.", "", "Concept -> rule -> ADR -> schema -> state machine -> API/event -> fixture -> validator -> implementation -> runbook", ""]
    for heading, paths in groups.items():
        lines.append(f"## {heading} ({len(paths)})")
        lines.append("")
        lines.extend(f"- [[{path}|{Path(path).name}]]" for path in sorted(paths))
        if not paths: lines.append("- None observed in the inspected checkout.")
        lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--workspace-root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--checkout-root", type=Path, default=None)
    parser.add_argument("--output-root", type=Path, default=None)
    parser.add_argument("--online", action="store_true")
    args = parser.parse_args()
    workspace_root = args.workspace_root.resolve()
    checkout_root = (args.checkout_root or workspace_root).resolve()
    output_root = (args.output_root or workspace_root).resolve()

    catalog = yaml.safe_load((workspace_root / "repos.yaml").read_text(encoding="utf-8"))
    evidence = yaml.safe_load((workspace_root / "registry/evidence.yaml").read_text(encoding="utf-8"))
    authority = yaml.safe_load((workspace_root / "registry/authority.yaml").read_text(encoding="utf-8"))
    jsonschema.validate(catalog, json.loads((workspace_root / "schemas/repos.schema.json").read_text(encoding="utf-8")))
    jsonschema.validate(evidence, json.loads((workspace_root / "schemas/evidence.schema.json").read_text(encoding="utf-8")), format_checker=jsonschema.FormatChecker())
    validate_catalog_semantics(catalog)
    evidence_audit = audit_evidence_artifacts(evidence, catalog, workspace_root, checkout_root)
    invalid_evidence = [row for row in evidence_audit if row["status"] != "digest_verified"]
    if invalid_evidence:
        raise ValueError("Evidence artifact verification failed: " + "; ".join(
            f"{row['claimId']}: {row['reason']}" for row in invalid_evidence))

    common = [inspect_checkout(entry, checkout_root, args.online) for entry in catalog["repositories"]]
    overlays = []
    for entry in catalog["repositories"]:
        for overlay in entry["institutionOverlays"]:
            overlays.append(inspect_checkout(overlay, checkout_root, args.online, overlay=True))
    snapshot = {
        "schemaVersion": 1,
        "generatedAt": dt.datetime.now(dt.timezone.utc).isoformat(),
        "online": args.online,
        "workspaceRoot": workspace_root.name,
        "checkoutRoot": checkout_root.name,
        "commonRepositories": common,
        "institutionOverlays": overlays,
        "evidenceAudit": evidence_audit,
    }

    generated = output_root / "Maps" / "Generated"
    generated.mkdir(parents=True, exist_ok=True)
    outputs = {
        "Workspace Command Center.md": render_command_center(snapshot, catalog, evidence),
        "Repository and Dependency Catalog.md": render_catalog(catalog),
        "Authority Map.md": render_authority(authority),
        "Evidence and Readiness Registry.md": render_evidence(evidence, evidence_audit),
        "Contract Explorer.md": render_contract_explorer(checkout_root),
    }
    for name, content in outputs.items():
        (generated / name).write_text(content.rstrip() + "\n", encoding="utf-8", newline="\n")
    status_path = output_root / "registry" / "generated-workspace-status.json"
    status_path.parent.mkdir(parents=True, exist_ok=True)
    status_path.write_text(json.dumps(snapshot, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Generated {len(outputs)} views and {status_path.relative_to(output_root)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
