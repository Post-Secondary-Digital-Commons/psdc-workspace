---
tags: [generated, command-center, evidence]
generated: true
generatedAt: 2026-10-08T06:21:45.061152+00:00
---

# Workspace Command Center

> Generated projection. Source authority remains in the Decision Register, ADRs,
> contracts, repository documents, and institution overlays. Regenerate with
> `python scripts/Build-WorkspaceCommandCenter.py --checkout-root C:\Users\jredj\dev\psdc --online`.

## Evidence boundary

`Proposed != Documented != Contracted != Structurally validated != Implemented != Deployed != Production proven`

## Current snapshot

- Common architecture baseline tag: **v0.1.0-draft**
- Catalog entries: **11 common / 11 institution overlays**
- Open pull requests observed: **1**
- Online observation errors: **0**; inspect `registry/generated-workspace-status.json` for bounded error details.
- Missing expected checkouts: **0**
- Markdown documents observed: **1696**
- Documents explicitly marked as stubs: **271**
- Broken-link count: **not assessed by this generator**; run `scripts/Test-Documentation.ps1` and ingest its report as evidence.
- Semantic-clone count: **not asserted by this generator**; use the architecture semantic audit.
- Security findings: **not assessed by this generator**; use pinned OpenSSF Scorecard and repository security scans.
- Test status: **command-center schemas and catalog semantics passed during generation**; **1** commit-bound common product test record(s) are indexed. Artifact digests resolve for **3/3** evidence records. This generator does not rerun their test commands or prove runtime behavior.
- Accepted decisions: **the Decision Register reports the project-controlled defaults accepted**; external approvals and measured deployment evidence remain separate gates.
- Next recommended vertical slice: **reconcile workload classification fields and the remaining lease/settlement authority blockers, then prepare the bounded H-006 D2 admission packet**. The indexed product evidence is structural, not implementation.

## Repository state

| Repository | Authority | Checkout status | Lifecycle | Revision | Open PRs | Docs | Stubs | Overlay sync | Contracts | Implementation |
|---|---|---|---|---|---|---|---|---|---|---|
| psdc-architecture | common | present | specification | d4cd881d dirty | 0 | 919 | 271 | not-applicable | partial | absent |
| psdc-cloud | common | present | specification | 8ec43433 | 0 | 11 | 0 | not-applicable | partial | absent |
| psdc-ai | common | present | specification | d016ab43 | 0 | 25 | 0 | not-applicable | partial | absent |
| psdc-compute | common | present | specification | f85a9771 | 0 | 18 | 0 | not-applicable | partial | absent |
| psdc-media | common | present | specification | bfdfb5f2 | 0 | 15 | 0 | not-applicable | partial | absent |
| psdc-social | common | present | specification | dc004718 | 0 | 13 | 0 | not-applicable | partial | absent |
| psdc-web | common | present | specification | 9d713407 | 0 | 7 | 0 | not-applicable | absent | absent |
| psdc-desktop | common | present | specification | 5da00a49 | 0 | 3 | 0 | not-applicable | absent | absent |
| psdc-mobile | common | present | specification | b817f360 | 0 | 4 | 0 | not-applicable | absent | absent |
| psdc-deployment-template | common | present | specification | d898b025 | 0 | 8 | 0 | not-applicable | partial | absent |
| psdc-agent-skills | common | present | specification | 68756388 | 0 | 29 | 0 | not-applicable | partial | absent |
| algonquin-architecture | institution | present | institution-specific | aa41e593 dirty | 1 | 528 | 0 | behind 4, ahead 21 | overlay-specific | overlay-specific |
| algonquin-cloud | institution | present | institution-specific | bfb0be7e | 0 | 12 | 0 | behind 0, ahead 8 | overlay-specific | overlay-specific |
| algonquin-ai | institution | present | institution-specific | 9c76ff5d | 0 | 26 | 0 | behind 0, ahead 9 | overlay-specific | overlay-specific |
| algonquin-compute | institution | present | institution-specific | b0f940b5 | 0 | 19 | 0 | behind 0, ahead 8 | overlay-specific | overlay-specific |
| algonquin-media | institution | present | institution-specific | 5685883e | 0 | 16 | 0 | behind 0, ahead 8 | overlay-specific | overlay-specific |
| algonquin-social | institution | present | institution-specific | bba608c8 | 0 | 14 | 0 | behind 0, ahead 8 | overlay-specific | overlay-specific |
| algonquin-web | institution | present | institution-specific | 9a7ad09d | 0 | 9 | 0 | behind 0, ahead 5 | overlay-specific | overlay-specific |
| algonquin-desktop | institution | present | institution-specific | 8016834e | 0 | 4 | 0 | behind 0, ahead 8 | overlay-specific | overlay-specific |
| algonquin-mobile | institution | present | institution-specific | 8224aaf2 | 0 | 5 | 0 | behind 0, ahead 8 | overlay-specific | overlay-specific |
| algonquin-deployment | institution | present | institution-specific | c255d1e8 dirty | 0 | 11 | 0 | behind 0, ahead 5 | overlay-specific | overlay-specific |
| algonquin-agent-skills | institution | planned | institution-specific | missing | 0 | 0 | 0 | not-applicable | overlay-specific | overlay-specific |

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
