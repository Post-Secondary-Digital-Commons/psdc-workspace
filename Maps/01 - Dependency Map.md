---
tags: [moc, dependency, architecture]
---

# Dependency Map


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

This map covers both local runtime dependencies and sovereign peer dependencies.
Federation never turns another institution into a local identity, policy,
database, LMS, secrets, or infrastructure-state authority.

## Canonical dependency documents

- [[common/psdc-architecture/docs/architecture/Ecosystem-Dependency-Contract]]
- [[common/psdc-architecture/docs/architecture/Dependency-Map]]
- [[common/psdc-architecture/docs/architecture/Failure-Domains]]
- [[common/psdc-architecture/docs/reliability/Dependency-Outage-Matrix]]
- [[common/psdc-architecture/docs/architecture/Control-Plane-vs-Data-Plane]]

## Direction

```text
open standards and shared contracts
               |
     Commons Cloud Fabric
               |
     +---------+----------+
     |         |          |
 Compute     AI       Media/Spatial
     \         |         /
      \        |        /
     Commons Social Fabric
               |
   Web + Desktop + Mobile clients
```

Arrows describe allowed service consumption, not database ownership. Commons Cloud has
no runtime dependency on product systems. Compute, AI and Media remain independently
deployable. Fediverse can operate text-only if AI or Media is unavailable.
Clients consume only gateway and versioned domain contracts; they never depend on
sibling databases, model runtimes, compute workers or institution-provider APIs.

## Required questions for every dependency

- Who owns the producer and contract?
- Is the dependency foundational, capability-only, asynchronous, development, or
  external?
- What authentication, scope and data classification apply?
- What happens on timeout, partial failure or version mismatch?
- Can work queue, degrade, fall back, or be disabled safely?
- How is the dependency monitored, upgraded, migrated and removed?

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **01 - Dependency Map**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

## Ownership boundaries

The owning repository remains authoritative for each capability. This workspace map may link and summarize, but it MUST NOT redefine a repository contract, institution policy, or signed deployment value.

## Scope and exclusions

The map covers the documents and repositories named in its links. It excludes secrets, private infrastructure values, unapproved vendor commitments, and implementation details that belong in the owning repository.

## Source of truth and references

The source of truth is the linked document in the owning repository plus its accepted ADRs and contracts. Links MUST remain relative inside a repository or use the canonical hosted repository URL when crossing repository boundaries.

## Validation and staleness

The map is valid only when links resolve, referenced documents retain their declared control blocks, and no newer accepted ADR contradicts the summary. Run scripts/Test-Documentation.ps1 and scripts/Test-DocumentQuality.ps1; stale or contradictory entries MUST be corrected or marked historical.
