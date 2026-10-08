#!/usr/bin/env python3
"""Adversarial check that evidence bytes remain bound to an immutable revision."""

from __future__ import annotations

import copy
import argparse
import importlib.util
import json
from pathlib import Path

import yaml


parser = argparse.ArgumentParser()
parser.add_argument("--checkout-root", type=Path, default=Path(r"C:\Users\jredj\dev\psdc"))
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("command_center", root / "scripts/Build-WorkspaceCommandCenter.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
catalog = yaml.safe_load((root / "repos.yaml").read_text(encoding="utf-8"))
evidence = yaml.safe_load((root / "registry/evidence.yaml").read_text(encoding="utf-8"))
checkout_root = args.checkout_root

valid = module.audit_evidence_artifacts(evidence, catalog, root, checkout_root)
assert len(valid) == len(evidence["evidence"])
assert all(row["status"] == "digest_verified" for row in valid), json.dumps(valid, indent=2)

bad_digest = copy.deepcopy(evidence)
bad_digest["evidence"][-1]["artifactDigest"] = "sha256:" + "0" * 64
result = module.audit_evidence_artifacts(bad_digest, catalog, root, checkout_root)
assert result[-1]["status"] == "unverified" and "SHA-256" in result[-1]["reason"]

bad_revision = copy.deepcopy(evidence)
bad_revision["evidence"][-1]["revision"] = "0" * 40
result = module.audit_evidence_artifacts(bad_revision, catalog, root, checkout_root)
assert result[-1]["status"] == "unverified" and "immutable GitHub blob" in result[-1]["reason"]

print(f"Evidence audit passed: {len(valid)} immutable artifact digests verified; bad digest and revision rejected.")
