# Ecosystem Skill Application Review

**Status:** Source-bound assessment for owner review

**Observed:** 2026-10-07 UTC

**Scope:** 11 active common repositories, 10 active Algonquin forks, the
workspace catalog, and one planned Algonquin skill overlay

**Decision authority:** The common Decision Register, accepted ADRs, contracts,
and each institution's local policy authority retain their existing precedence.

## Result

The governed skill pack is now pinned in every active product or institution
repository. Root `AGENTS.md` routes Codex and other agents to the same
repository manifest; `CLAUDE.md` points to that file. The skill pack's
schema and validator checked all 20 product and institution manifests, and the
workspace adoption audit checked 21 active `origin/main` revisions. The one
uncreated `algonquin-agent-skills` overlay is marked planned.

That is evidence for **agent routing and manifest structure**. It does not
show that every document has been reviewed by an agent, that an agent obeyed
every rule, or that any PSDC product runtime has been built.

The source snapshot and per-repository result are in
[`generated-skill-adoption.json`](../../registry/generated-skill-adoption.json).
Each row names the inspected commit and manifest blob. The generated
[[Maps/Generated/Ecosystem Skill Adoption|Obsidian view]] is an index over the
same data.

## Methods applied

| Governed method | Application in this pass | Limit |
|---|---|---|
| Domain modeling | Distinguished common fabric, institution overlay, browser client, gateway, runtime dependency, and capability dependency | Glossaries across all product contexts still need term-by-term review |
| Grill with docs | Challenged ambiguous ownership and readiness language against accepted decisions | No new human decision was inferred or accepted |
| To spec | Added a bounded manifest contract and an evidence-backed workspace adoption specification | Product implementation specifications remain owned by their repositories |
| Wayfinder | Identified the first concrete artifact needed in each repository and the blocked edges below | No tracker issues were created |
| Writing for agents | Added short, repository-specific `AGENTS.md` files and a single Claude pointer; kept the common policy in one place | Behavioral compliance of agents is not yet tested |
| Project assessment | Scored twelve ecosystem dimensions below at named source revisions | A system score is not a score for every document |
| Evidence audit | Bound adoption claims to main revisions, manifest blobs, and validator results | Runtime and deployment claims remain unverified |

## Decisions and conflicts checked

1. **Cloud and Compute dependency.** The accepted
   [Ecosystem Dependency Contract](https://github.com/Post-Secondary-Digital-Commons/psdc-architecture/blob/6405e9bc138cb820162984c96d0439d82c88e54d/docs/architecture/Ecosystem-Dependency-Contract.md)
   forbids Cloud core services from requiring Compute to authenticate, route,
   observe, or recover. The earlier workspace catalog listed Compute as
   required by Cloud. The catalog now treats Compute as an optional Cloud
   capability.
2. **AI and Compute dependency.** The same contract classifies Compute as a
   capability for AI requests, with local-runtime fallback or queuing. The
   earlier catalog required Compute for AI. It is now optional; the required
   dependency set is architecture plus Cloud.
3. **Browser-client ownership.**
   [ADR-0025](https://github.com/Post-Secondary-Digital-Commons/psdc-architecture/blob/6405e9bc138cb820162984c96d0439d82c88e54d/docs/architecture/architecture-decision-records/ADR-0025-independent-web-client-repository.md)
   assigns browser source and releases to `psdc-web` and the thin
   `algonquin-web` fork. Common and Algonquin AI READMEs and layout guides
   still described `apps/web` as the import target. Those guides now point
   to the independent clients; `apps/web` remains a migration notice.
4. **Readiness wording.** Current remote `main` in `psdc-web` and
   `algonquin-web` says documentation and architecture are complete while
   implementation has not started. The older local feature branches used
   shorter `Status: Complete` headings. This review uses the remote main
   snapshot and does not mistake the older working branches for current main.
5. **Institution sovereignty.** Common skill manifests point to the common
   decision and contract authority. Algonquin manifests add
   `algonquin-deployment` as institution policy authority. This routing
   cannot override a local approval or signed deployment value.

## Ecosystem rubric

The score is for the **whole architecture and current repository set** at
the revisions in the generated snapshot. The rubric is 0 missing or
contradicted, 1 proposed, 2 coherently documented, 3 contracted with
structural positive and negative evidence, and 4 implemented with behavioral
verification. A lower ecosystem score can coexist with stronger evidence in
one repository.

| Dimension | Score | Evidence and counter-evidence | Next evidence for a higher score |
|---|---:|---|---|
| Authority and decision traceability | 2 | Decision Register, accepted ADRs, authority map, and scoped manifests exist; automatic contradiction tracing across every repo does not | Machine-linked decision IDs to owning contracts and consumers |
| Domain vocabulary and bounded contexts | 2 | Catalog roles and client/fabric boundaries are explicit; older local branches and some product docs retain legacy names | Reviewed glossary terms per context with cross-repository translation rules |
| Dependencies and interfaces | 2 | Accepted dependency matrix and corrected catalog exist; interface names have no normative artifact binding | Registry mapping each interface to schema, API/event, owner, version and failure profile |
| Contract completeness and compatibility | 2 | Architecture has schemas, state machines, fixtures, and validators for selected flows; coverage is incomplete | End-to-end trace for one interface, then all required interfaces |
| Identity, authorization, privacy and consent | 2 | Institutional authority and consent rules are documented; policy enforcement and account portability are not running | Negative authorization, withdrawal, revocation, and transfer tests against an implementation |
| Failure, retry, revocation and idempotency | 2 | Dependency contract specifies fallbacks and compute candidates specify lifecycle behavior; no runtime proof | Executable failure fixtures at API and worker boundaries |
| Federation and sovereignty | 2 | Peer and overlay authority boundaries are accepted; no verified cross-institution exchange | Two independent deployments passing trust, revocation, and data-disposition conformance |
| Licensing and provenance | 2 | Skill upstream commit, MIT notice and hashes are pinned; client upstream imports remain gated | Source-import inventories, license review, SBOMs, and release attestations |
| Independent negative testing | 2 | Contract fixtures and structural validators exist; this pass validated manifests but did not test product behavior | Adversarial mutation tests plus independent reviewer results for each handoff |
| Operations and observability | 1 | Runbooks and telemetry are specified; no campus service is deployed | Environment, SLO, incident, restore, and live telemetry evidence |
| Documentation quality and uniqueness | 1 | A document standard and explicit stub marker exist; common architecture still has 271 declared stubs | Review and close stubs without cloning generic text; rerun semantic and link audits |
| Implementation handoff and slices | 2 | Candidate vertical slices and acceptance language exist; some named interfaces lack exact contract links | One complete, independently checkable schema-to-API-to-fixture-to-consumer handoff |

These scores are review judgments. Counts, commit IDs, and manifest checks are
observations; the score does not substitute for independent validation.

## Repository-by-repository next artifact

| Repository | Governed context | Highest-value next artifact or check |
|---|---|---|
| `psdc-architecture` | Common decisions and contracts | Bind `workload.submit.v1` to its normative operation, lifecycle, positive/negative fixtures, compatibility policy, and owner; keep stub closure separate |
| `psdc-cloud` | Identity, policy, events, shared services | Define `identity.verify.v1` and `cloud.service.v1` as exact producer contracts with outage behavior |
| `psdc-ai` | Gateway, sessions, model routing | Complete the AI session and route contract trace; verify local-runtime fallback when Compute is absent |
| `psdc-compute` | Providers, workload placement, leases, storage | Finish the census/enrollment tracer and lease authority tests before runtime handoff |
| `psdc-media` | Asset, rights, rendition, spatial media | Bind object/asset manifests to rights, retention, processing, and failure evidence |
| `psdc-social` | ActivityPub, actors, moderation | Trace local actor authority through inbox/outbox, peer policy, moderation, and revocation fixtures |
| `psdc-web` | Browser/PWA and BFF | Verify signed deployment discovery and the BFF gateway boundary with negative client-bypass tests |
| `psdc-desktop` | Desktop client | Prove eligible OpenWork source inventory and test signed institution discovery before import |
| `psdc-mobile` | Mobile companion | Prove eligible Happy source inventory and content-blind relay/pairing contract before import |
| `psdc-deployment-template` | Neutral deployment composition | Contract and validate a signed manifest plus compatibility lock across pinned components |
| `psdc-agent-skills` | Skill policy and assessment | Test real agent behavior against the repository change boundary and schema-validate assessment output |
| `algonquin-architecture` | Local decision and deployment context | Reconcile the latest common baseline with local binding sections without promoting local policy to common authority |
| `algonquin-cloud` | Local identity and cloud binding | Record approved IdP, PKI, DNS/IPAM, and failure ownership as institution evidence |
| `algonquin-ai` | Local AI policy and models | Bind institution model aliases, academic adapters, and capacity envelopes to common contracts |
| `algonquin-compute` | Campus provider estate | Produce an authorized hardware census, lab network profile, and non-disruption pilot gate |
| `algonquin-media` | Local media policy | Bind capture consent, student rights, retention, and storage classification |
| `algonquin-social` | Local social node | Record actor domains, moderation authority, approved peers, and incident contacts |
| `algonquin-web` | Branded browser release | Validate institution branding, issuer discovery, domains, legal links, and release signature |
| `algonquin-desktop` | Branded desktop distribution | Define managed-campus and personal-device distribution gates, signing, and rollback |
| `algonquin-mobile` | Branded mobile distribution | Define store and portable package channels, pairing, privacy evidence, and signing |
| `algonquin-deployment` | Local deployment authority | Provide site topology, network ranges, KMS/CA ownership, approvals, and recovery objectives |
| `algonquin-agent-skills` | Planned local skill overlay | Create only after defining the minimal local approval, contact, and policy binding files |

## Handoff sequence and blocking edges

1. **Interface traceability.** Owner: common architecture. Register
   `workload.submit.v1` against the existing compute schema, operation,
   state machine, event, fixture set, validator, and compatibility rule.
   **Blocks:** a reliable workload consumer handoff.
2. **Evidence producer.** Owner: workspace and one pilot product repository.
   Ingest a commit-bound structural test result without promoting the product
   beyond structural validation. **Blocks:** trustworthy command-center test
   status and readiness rollups.
3. **Institution profile.** Owner: Algonquin deployment. Bind identity,
   network, KMS, and retention choices to one signed draft profile.
   **Blocked by:** owner-approved local values; **blocks:** a meaningful
   campus pilot.
4. **Client boundary slice.** Owner: web and AI. Exercise signed discovery,
   browser BFF, gateway, local inference, and a negative direct-provider test.
   **Blocked by:** exact interface binding; **blocks:** a truthful end-to-end
   user-session claim.
5. **Federation slice.** Owner: Social plus deployment. Exchange a test
   ActivityPub activity between two sovereign peers with revocation and
   moderation evidence. **Blocked by:** local actor/peer policy bindings.

These are handoff candidates, not created GitHub issues or accepted new
implementation decisions.

## Verification performed and limits

- The common skill pack structural test passed for ten registered skills.
- The consumer validator passed for each of the 20 product/institution
  manifests and the workspace manifest.
- The adoption generator inspected 22 catalog identities at local
  `origin/main` refs: 21 validated and one planned.
- The catalog schema and semantic validator accept the revised dependency
  graph and reject required-dependency cycles.
- `git diff --check` passed on the edited repository branches.
- The workspace-wide link checker run against isolated flat worktrees found
  one link from an existing architecture audit to the workspace
  `scripts/Test-DocumentQuality.ps1` outside that test root. That check is
  **not** claimed as passing. The edited agent pointers and AI ownership links
  were inspected at their target paths.
- Existing architecture stubs, legal approvals, hardware inventories,
  runtime tests, deployments, and production observations were not resolved
  by this skill rollout.
- Claude Code cross-review remains unavailable under the organization
  subscription setting; no Claude finding is represented here.

## Reproduction

From the workspace checkout:

```powershell
python scripts/Build-Ecosystem-Skill-Adoption.py --checkout-root C:\Users\jredj\dev\psdc
pwsh -NoProfile -File scripts/Test-WorkspaceCommandCenter.ps1
```

Fetch `origin/main` in each independent checkout before refreshing the first
command. Inspect the JSON rows for exact revisions. A validated manifest is
only the beginning of skill application: the next review must resolve source
findings and commit evidence for the chosen interface and vertical slice.
