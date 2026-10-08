# Evidence and Readiness Registry

> Generated from `registry/evidence.yaml`. Evidence states are ordered: proposed -> documented -> contracted -> structurally_validated -> implemented -> deployed -> production_proven. `digest_verified` proves only that the artifact bytes match the named Git revision; it does not rerun the listed verification.

| Claim | Scope | State | Artifact digest check | Artifact | SHA-256 | Revision | Verification claim |
|---|---|---|---|---|---|---|---|
| workspace.catalog.v3 | common-and-algonquin | documented | digest_verified | repos.yaml | sha256:8fee32ddd9527c52b4d358f26edd468a5c31b9d1026eb8409064912851e522bd | cc1b7af4a8624c383ccbb85f4eac79ad5794ed76 | Validate against schemas/repos.schema.json and render the command center. |
| workspace.command-center.generator.v1 | common-and-algonquin | structurally_validated | digest_verified | scripts/Build-WorkspaceCommandCenter.py | sha256:01675c4e28d9a2723734d004f02e50e4b56cfe9564cb0436b2197f8362103f64 | cc1b7af4a8624c383ccbb85f4eac79ad5794ed76 | Run scripts/Test-WorkspaceCommandCenter.ps1. |
| architecture.workload-submit.bindings.v1 | common-psdc-architecture | structurally_validated | digest_verified | https://github.com/Post-Secondary-Digital-Commons/psdc-architecture/blob/a8a5b0f72d133957db24d7f7f2a184d02f08e6fd/contracts/traceability/workload-submit.trace.json | sha256:7044aafa82216ce87c3a5924f467f98ab6278f4eb4f58af5d95a491a41fbea3e | a8a5b0f72d133957db24d7f7f2a184d02f08e6fd | In a detached worktree at the revision, npm ci and npm run test:contracts exited 0; 36 schemas, 54 fixtures, eight binding mutations, and a 131-file reproducible bundle passed. |
