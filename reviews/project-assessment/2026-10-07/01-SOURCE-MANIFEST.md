# Assessment Source Manifest

The assessment used the following immutable Git objects. SHA-256 is calculated
over the exact blob bytes returned by `git show <revision>:<path>`. This manifest
replaces the earlier concatenated review input so authoritative documents are
not duplicated as semantic clones inside the workspace repository.

| Repository | Revision | Path | SHA-256 |
|---|---|---|---|
| psdc-workspace | `cc1b7af4a8624c383ccbb85f4eac79ad5794ed76` | `repos.yaml` | `8fee32ddd9527c52b4d358f26edd468a5c31b9d1026eb8409064912851e522bd` |
| psdc-workspace | `cc1b7af4a8624c383ccbb85f4eac79ad5794ed76` | `docs/command-center/Workspace-Command-Center-Specification.md` | `0bc99c60df800dde2710379cf2fd10e56f1c41ca75ed7467c09c2f77c708f189` |
| psdc-workspace | `cc1b7af4a8624c383ccbb85f4eac79ad5794ed76` | `Maps/Generated/Workspace Command Center.md` | `7f1faef50d39cd9ae553dfd117f5956f52e33625dae6556d79405fdeff25961b` |
| psdc-agent-skills | `984e54b2612bb8b5969b83d17eee831f5d5badcb` | `docs/architecture/SKILL-ADOPTION.md` | `c70c904ee9e2165cd6c16f5058ed69523d42c5c1d590257741c47561c68d723c` |
| psdc-agent-skills | `984e54b2612bb8b5969b83d17eee831f5d5badcb` | `skills/psdc-project-assessment/references/rubric.md` | `107426dc97cbfc89b7958882ef7c01af3642dbc423748591f8b9a72490ebe001` |
| psdc-architecture | `d4cd881d3dab31dfebe6c60b9acba749d1c3b45c` | `docs/vision/constitutional/PSDC-Platform-Reference-Architecture.md` | `a96b2f56413d4c31a866fa88bedac72801ce7bb9bcde2434da89405e2fdc9024` |
| psdc-architecture | `d4cd881d3dab31dfebe6c60b9acba749d1c3b45c` | `docs/architecture/Ecosystem-Dependency-Contract.md` | `7b72ec3b5fe8331df8b90d25e407a4965e5cd58b4de6b9e96ff07ebacf9b79b3` |
| psdc-architecture | `d4cd881d3dab31dfebe6c60b9acba749d1c3b45c` | `docs/architecture/architecture-decision-records/ADR-0033-dual-lane-adaptive-ai-sessions.md` | `16f3ff5932ba0cf3b01cd752d78844c7e691cf67bdd706070881667a72e91eae` |
| psdc-architecture | `d4cd881d3dab31dfebe6c60b9acba749d1c3b45c` | `docs/architecture/architecture-decision-records/ADR-0034-governed-agent-skills-and-workspace-knowledge-plane.md` | `2d939bac9345a4f3797f4230c74b79742148c55e3c36269b83d14b4282d79f06` |

## Review outputs

- `03-QWEN-COMMAND-CENTER.md` — focused Qwen3 14B output.
- `04-QWEN8-SKILLS-CATALOG.md` through `07-QWEN8-DEPENDENCY-CONTRACT.md`
  — bounded Qwen3 8B outputs.
- `08-CLAUDE-CODE-BLOCKED.md` — failed independent-review attempt.
- `09-CODEX-REVIEW-AND-DISPOSITION.md` — source-checked disposition.

Raw model output is retained separately from the disposition. A model finding
does not modify the immutable sources named above.
