# Codex Review and Local-Model Finding Disposition

**Date:** 2026-10-07  
**Scope:** Workspace command center, governed skill pack, catalog, dual-lane AI ADRs, reference architecture, and dependency contract  
**Evidence boundary:** Documentation and structural validation only; runtime implementation and production operation are not proven  
**Independent Claude pass:** Not completed; see `08-CLAUDE-CODE-BLOCKED.md`

## Executive assessment

The skill pack and command center establish a coherent, open, source-controlled
knowledge plane without granting generated Obsidian notes independent authority.
The catalog migration preserved all prior repository pairs and added one common
skill repository plus one explicitly planned institution overlay. Structural
validation is real, but the architecture remains documentation-first: the
online snapshot still reports 271 explicit common-architecture stubs and no
product implementation or deployment evidence. The local models were useful as
question generators, but several findings were caused by bounded packets and
must not be accepted without repository verification. The next implementation
work should make one interface and one evidence claim executable end to end.

## Rubric

Scores use 0 absent, 1 named, 2 partially specified, 3 implementation-grade,
and 4 independently evidenced in operation.

| Dimension | Score | Evidence | Needed for next score |
|---|---:|---|---|
| Purpose and scope | 3 | Command-center and skill-adoption specifications define users, boundaries, exclusions, and lifecycle | Owner approval and stable acceptance record |
| Authority clarity | 3 | Machine-readable authority registry and generated map preserve precedence | Automated contradiction reporting tied to exact source revisions |
| Repository topology | 3 | Schema-3 catalog and migration proof preserve all pairs | Owner review of roles and lifecycle values |
| Dependency model | 2 | Required/optional edges validate and render | Contract references and compatibility ownership for every interface |
| Contract coverage | 2 | Architecture contracts exist and explorer indexes them | Replace remaining declarations/stubs with implementation-grade contracts |
| Evidence integrity | 2 | Registry records claims, verification, time, and limitations | Immutable artifact digests, signed attestations, and automated producers |
| Documentation maturity | 2 | Generator and specifications are substantive | Resolve 271 explicit architecture stubs and remaining semantic/link debt |
| Testability | 3 | Schema, semantics, generation, and skill validators pass | Adversarial fixtures and CI on a self-hosted runner |
| Security and privacy | 2 | Least-authority rules and no readiness inflation are documented | Threat model, role authorization, provenance scanning, and runtime tests |
| Operability | 1 | Failure behavior and future portal phases are specified | Deployed portal, refresh job, monitoring, backups, and runbooks |
| Federation/overlay fit | 3 | Common authority and thin institution overlays are distinct | Create and validate the planned Algonquin skill overlay |
| Review reproducibility | 2 | Raw model outputs and bounded brief are retained | Digest-pinned packet builder and completed independent Claude pass |

## Findings

### 1. High — documentation debt remains material

**Basis:** The generated snapshot detects 271 documents explicitly marked as
stubs in the common architecture checkout.  
**Failure scenario:** A maintainer treats catalog presence or a green generator
as proof that subsystem specifications are implementation-grade.  
**Smallest remediation:** Continue the established document standard in
dependency order, and ingest the architecture semantic/link validators as
separate evidence producers. Do not alter the dashboard to hide stubs.

### 2. High — interface names are not yet bound to normative contract artifacts

**Basis:** `repos.yaml` declares `provides` and `consumes`, but an interface ID
does not yet carry a contract URI, owning authority, version-compatibility
policy, or maturity record.  
**Failure scenario:** Two repositories agree on a name while implementing
incompatible payloads or state semantics.  
**Smallest remediation:** Introduce an interface registry whose entries bind the
ID to a contract artifact and compatibility policy; keep repository records as
references to that registry.

### 3. High — evidence records are not yet immutable attestations

**Basis:** The initial records used `working-tree`. This review remediated the
immediate reproducibility defect with immutable commit IDs and artifact SHA-256
digests; cryptographic signatures are still absent.
**Failure scenario:** A later edit changes the artifact while an old evidence
claim appears to describe it.  
**Smallest remediation:** Later replace manual YAML with signed
in-toto-compatible attestations and verify them in the generator.

### 4. Medium — the catalog schema validates shape more strongly than meaning

**Basis:** Top-level typo acceptance was closed in this review, but `defaults`
and `governance` remain intentionally open objects and roles/interfaces remain
free-form strings.  
**Failure scenario:** A misspelled governance field parses successfully and is
silently ignored by future automation.  
**Smallest remediation:** Add versioned schemas for defaults, governance,
interface records, and controlled lifecycle vocabulary before consumers rely on
those fields for enforcement.

### 5. Medium — online status is observational and partially fallible

**Basis:** GitHub CLI data is point-in-time; the snapshot carries generation
time and bounded per-repository errors, but has no freshness policy.  
**Failure scenario:** A cached dashboard is read as current after branch or PR
state changes.  
**Smallest remediation:** Add freshness/expiry policy and visually mark stale
online fields; retain last-known state separately from the latest refresh error.

### 6. Medium — contract explorer presence is not traceability

**Basis:** The explorer inventories files but does not yet link concept, rule,
ADR, schema, operation, event, fixture, validator, implementation, and runbook
as one machine-checked chain.  
**Failure scenario:** A contract appears complete because a schema exists even
though no API operation or state transition uses it.  
**Smallest remediation:** Add stable traceability IDs and require each chain to
name its predecessor and successor artifacts.

### 7. Medium — local model context and reliability are insufficient for a monolithic review

**Basis:** The observed Ollama sessions used a 4,096-token context. The 14B
all-in-one attempt lost instruction fidelity, and several 8B findings declared
artifacts missing when they were merely outside the packet.  
**Failure scenario:** A fluent but source-incomplete finding is promoted into
architecture or backlog work.  
**Smallest remediation:** Use digest-pinned bounded packets, mandatory citations,
schema-validated results, and human/Codex disposition before remediation.

### 8. Medium — the independent model cross-review is incomplete

**Basis:** Claude Code stopped before review because organization subscription
access is disabled.  
**Failure scenario:** The review is described as cross-validated when only Qwen
and Codex completed passes.  
**Smallest remediation:** Enable approved Claude access or run the prepared
bounded packet interactively, then commit raw output and a source-checked
disposition as distinct artifacts.

### 9. Low — role projections remain information architecture, not access control

**Basis:** Student, faculty, operator, security, and auditor views are specified
but no authorization layer exists.  
**Failure scenario:** A future portal exposes privileged operational data merely
because it can render the same catalog.  
**Smallest remediation:** Define projection authorization and field-level data
classification before implementing role-specific interfaces.

### 10. Low — the planned overlay needs an explicit creation gate

**Basis:** `algonquin-agent-skills` is planned and intentionally absent. The
dashboard now labels it planned, but no creation decision or acceptance gate is
recorded.  
**Failure scenario:** Someone assumes it should already exist or creates a
full copy rather than a thin institution overlay.  
**Smallest remediation:** Add a backlog item gated on common PR acceptance and
define the minimal Algonquin-only policy, branding, and approval files.

## Local-model finding disposition

| Local finding | Disposition | Evidence and action |
|---|---|---|
| Evidence levels need explicit mapping | Duplicate | The ladder and evidence registry already define the boundary; no readiness promotion occurs from file counts |
| Missing Algonquin skill checkout resembles deletion | Confirmed and remediated | Added explicit `planned` checkout status and a schema migration proof |
| Dirty checkouts are non-reproducible | Confirmed and remediated | Dashboard warns that `HEAD` cannot attest uncommitted content |
| `assessment.result.v1` does not exist | Packet limitation/rejected | The agent-skill repository contains its assessment schema; catalog posture remains partial because no runtime consumer exists |
| No skills or tests exist | Packet limitation/rejected | Two PSDC-native skills and pinned upstream skills exist and pass repository validators |
| Deployment manifest implementation is absent | Confirmed, expected | Catalog already declares implementation and deployment absent |
| Context packages may become a profiling channel | Partly confirmed | Existing policy and opt-in constraints reduce the risk; runtime authorization, expiry, and audit tests remain future work |
| KV cache portability is unsafe | Duplicate | ADR-0033 rejects cross-model KV portability; implementation tests remain absent |
| Skill provenance is missing | Rejected for current branch | Upstream commit, paths, MIT license, notices, and content hashes are pinned in `psdc-agent-skills` |
| Capacity degradation has no runtime proof | Confirmed | Architecture rule exists, implementation and failure tests do not |
| Response availability/pacing is unimplemented | Confirmed | It is an accepted contract candidate, not a deployed mechanism |
| Federation peers may become identity authorities | Rejected | Reference architecture and dependency contract explicitly forbid that promotion |
| Signed manifests create private imports | Rejected | A signed manifest is a shared contract artifact, not a source-code import |
| Local academic provider permits client bypass | Rejected | The architecture requires gateway/adapter mediation; the provider is a deterministic boundary, not client database access |
| Fediverse identity is institutional identity | Rejected | The dependency contract separates federated social identity from institutional authority |

## Checked and found sound

- The source-authority ordering is explicit and generated notes cannot supersede it.
- The schema-2 catalog content is preserved one-for-one in schema 3.
- Missing local checkout, planned repository, and remote deletion are now distinct states.
- Dirty working trees are displayed without being promoted to accepted evidence.
- Generator tests use a verified temporary directory and no longer overwrite the online snapshot.
- Contract-explorer links preserve full JSON filenames.
- Upstream skills are pinned by commit, license, path, and content digest.
- Implementation-capable upstream skills remain deferred while the project is documentation-first.
- The dual-lane AI design distinguishes generated-response availability from presentation pacing and rejects model-portable KV caches.
- No local model or generated dashboard is allowed to self-promote project readiness.

## Claims not verified

- Runtime correctness, authorization, transactionality, performance, capacity,
  privacy enforcement, recovery, or federation interoperability.
- Accuracy of all 271 stub classifications beyond their explicit status marker.
- Current security posture across every product repository.
- A successful Claude review.
- Production suitability of Qwen on campus hardware or concurrent student load.

## Next three tracer-bullet slices

1. **Evidence slice:** one repository emits a digest-bound structural-test
   result; the command center validates and displays it without changing the
   repository's implementation state.
2. **Interface slice:** bind `workload.submit.v1` to its normative schema,
   operation, state transition, positive fixture, negative fixture, validator,
   and a no-op reference consumer.
3. **Institution-overlay slice:** create the thin Algonquin agent-skill overlay,
   prove upstream provenance and local-only policy separation, then exercise
   sync reporting.

## Readiness warning

This review improves specifications, visibility, and structural checks. It does
not prove that any PSDC product service has been implemented, deployed, or
operated successfully.
