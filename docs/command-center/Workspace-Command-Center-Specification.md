# Workspace Command Center Specification

**Status:** Draft for owner review  
**Authority:** Explanatory specification; the Decision Register, ADRs, and
contracts remain normative  
**Implementation state:** Static generator implemented and structurally tested;
portal and runtime integrations are not implemented

## Purpose

The command center answers one question without overstating the answer: **what
do we know about the ecosystem at this revision, and what evidence supports
it?** It combines machine-readable declarations with observed checkout and
GitHub state, then generates Obsidian-friendly views.

It must always preserve this boundary:

```text
Proposed
  != Documented
  != Contracted
  != Structurally validated
  != Implemented
  != Deployed
  != Production proven
```

## Users and projections

The command center is one governed information model with multiple projections.
It must not create duplicate identity, policy, contract, or storage authorities.

| Projection | Primary questions | Additional data when authorized |
|---|---|---|
| Student | What can I use, learn, and contribute to? | Courses, projects, credentials, compute usage |
| Faculty | What is approved for teaching and research? | Tutoring policy, evaluation, research controls |
| Developer | What interfaces exist and what can I implement next? | Contracts, traces, sandboxes, model routes |
| Operator | What is running and failing? | Capacity, queues, SLOs, deployments |
| Security | Which trust decisions and findings need action? | Identity, alerts, audit evidence |
| Researcher | Can this result be reproduced? | Datasets, notebooks, models, experiments |
| Governance | Which decisions, agreements, and budgets are unresolved? | Proposals, votes, federation agreements |
| Institution administrator | What can this institution specialize? | Branding, bindings, quotas, approvals |
| Federation operator | Which partners and gateways are trusted? | Transport, settlement, federation health |
| Auditor | What immutable evidence supports a claim? | Read-only evidence without operational authority |

## Source model

### Repository and dependency catalog

`repos.yaml` owns repository identity, bounded role, authority, lifecycle,
dependencies, interfaces, institution overlays, and declared evidence posture.
The shape is validated by `schemas/repos.schema.json`.

Its relationship model deliberately resembles the open-source Backstage catalog:
human-maintained YAML entities, stable names, lifecycle, ownership, dependencies,
and APIs. This keeps future conversion feasible without requiring a Backstage
service now. Backstage documents component relationships through fields such as
`dependsOn`, `providesApis`, and `consumesApis` in its
[catalog descriptor format](https://backstage.io/docs/features/software-catalog/descriptor-format/).

### Authority map

`registry/authority.yaml` declares precedence. Generated Markdown is a view of
that source and cannot overrule it.

### Evidence registry

`registry/evidence.yaml` answers:

- what exact claim is made;
- which common or institution scope it applies to;
- which evidence state is asserted;
- which immutable revision or artifact supports it;
- who or what produced it;
- how it was verified;
- when it was observed and expires;
- what it does not prove.

The later attestation format should be compatible with in-toto/SLSA concepts:
an identified subject, producer/builder, process, and immutable digest. SLSA
defines provenance as verifiable information about where, when, and how an
artifact was produced; PSDC applies the same discipline to documentation,
contract, test, and deployment evidence. See the
[SLSA provenance specification](https://slsa.dev/spec/v1.2/).

### Contract explorer

The generated explorer inventories JSON Schema, OpenAPI, AsyncAPI, state
machines, fixtures, and validators. It is an index, not a conformance result.
The intended navigation chain is:

```text
Concept -> glossary -> architecture rule -> ADR -> schema -> state machine
        -> API/event -> fixture -> validator -> implementation -> runbook
```

When a web projection is introduced, use open-source
[Swagger UI](https://swagger.io/docs/open-source-tools/swagger-ui/usage/installation/)
for OpenAPI and the [AsyncAPI toolchain](https://www.asyncapi.com/docs/tools/cli/usage)
for event contracts. Pin versions and serve assets locally.

## Generated dashboard contract

The dashboard shows:

1. common architecture baseline tag;
2. each common repository and institution overlay revision;
3. dirty checkout state and missing checkouts;
4. open pull requests when online refresh is requested;
5. declared lifecycle and documentation/contract/implementation/deployment posture;
6. evidence records and their limitations;
7. document and explicit-stub counts;
8. authority precedence;
9. contract inventory;
10. the next bounded vertical slice.

It explicitly reports unsupported fields as **not assessed**. Semantic-clone,
security, test, and deployment claims require their own producer and evidence
record rather than being guessed from file presence.

## Open-source architecture

### Phase 1: static-first command center — implemented in this branch

- YAML + JSON Schema are the source contracts.
- Python, PyYAML, and `jsonschema` validate and generate views.
- Git supplies local revision and dirty-state observations.
- GitHub CLI optionally supplies point-in-time pull-request observations.
- Markdown and Mermaid render in Obsidian or any compatible editor.

This phase has low operational cost, works offline, and matches the current
documentation-first maturity. Obsidian remains optional and proprietary; the
canonical artifacts are plain Markdown, YAML, JSON, and Git.

### Phase 2: static web portal — specified, not implemented

Use [MkDocs](https://www.mkdocs.org/) to build the same generated Markdown into
static HTML. Add locally served Swagger UI and AsyncAPI views. Generate
dependency and authority diagrams from the same catalog. Do not create a second
catalog database.

### Phase 3: developer portal — conditional, not selected

Evaluate Apache-2.0 Backstage when the number of repositories, teams, runtime
systems, and operational plugins makes a persistent portal worth its Node.js,
database, identity, upgrade, and plugin-security burden. Import or generate
Backstage `catalog-info.yaml` from `repos.yaml`; do not maintain both manually.

### Security and supply-chain extensions

- Use [OpenSSF Scorecard](https://scorecard.dev/) as one security signal, never
  as a release oracle.
- Produce SPDX or CycloneDX SBOMs once buildable artifacts exist.
- Sign release artifacts and attestations once a release pipeline exists.
- Store scan results as evidence records tied to commit and scanner version.

## Control flow

```text
repos.yaml + authority.yaml + evidence.yaml
                 |
                 v
        schema validation (fail closed)
                 |
                 v
 local Git observations -- optional GitHub observations
                 |
                 v
 generated JSON snapshot + Markdown/Obsidian views
                 |
                 v
 optional MkDocs/Backstage projections later
```

The generator reads but does not change product repositories or GitHub state.

## Failure model

| Failure | Required behavior |
|---|---|
| Invalid catalog/evidence | Stop generation; retain the last reviewed output |
| Missing checkout | Report unknown/missing; do not infer remote deletion |
| GitHub unavailable | Generate local view and mark online fields not queried |
| Dirty checkout | Show dirty without reading uncommitted content as accepted authority |
| Stale evidence | Mark expired; never silently refresh the observation date |
| Conflicting authority | Report the conflict and link both sources |
| Unsupported security/test claim | Display not assessed rather than zero findings |

## Acceptance criteria

1. Both registries validate against their schemas.
2. Every dependency resolves to a catalog repository.
3. Every consumed interface has exactly one common provider or an explicit
   external-adapter declaration.
4. Every generated file names its source and generated status.
5. Local-only generation succeeds without network access.
6. Online failure cannot corrupt the local snapshot.
7. Generated views contain no secrets or repository credentials.
8. An institution overlay can be absent locally without breaking common views.
9. Tests distinguish a declared evidence posture from observed runtime evidence.
10. Future portals consume the same source records rather than creating a new
    authority.

## Immediate gaps

- Catalog interface names are draft declarations pending subsystem-owner review.
- The decision register is linked but not yet parsed into a decision schema.
- Test, semantic-audit, and security producers do not yet emit evidence records.
- Evidence records use human-readable YAML; signed in-toto-compatible
  attestations are a later implementation slice.
- No role-specific UI or authorization layer exists.
- No Backstage, MkDocs, Swagger UI, or AsyncAPI service has been deployed.
- `algonquin-agent-skills` is planned and has not been created.

## Related records

- `Catalog-Migration-v2-to-v3.md` proves that the richer catalog representation
  preserved every schema-2 common/Algonquin repository pair.
- `Local-Model-Assessment-Workflow.md` scopes the bounded Qwen, Codex, and
  Claude cross-review process without treating model agreement as evidence.
