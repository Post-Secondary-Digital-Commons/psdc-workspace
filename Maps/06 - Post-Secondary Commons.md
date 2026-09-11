---
tags: [moc, commons, federation, architecture]
---

# Post-Secondary Digital Commons


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

## Constitutional model

- [[common/psdc-architecture/docs/vision/constitutional/Post-Secondary-Digital-Commons-Architecture]]
- [[common/psdc-architecture/docs/architecture/Federated-Commons-Naming-and-Sovereignty]]
- [[common/psdc-architecture/docs/fediverse/Federated-Social-Governance-Policy]]
- [[common/psdc-architecture/docs/clients/Institution-Branded-Client-Distribution-and-Access]]
- [[common/psdc-architecture/docs/architecture/Consolidated-Ecosystem-Architecture]]
- [[common/psdc-architecture/docs/architecture/Ecosystem-Dependency-Contract]]
- [[common/psdc-architecture/docs/architecture/Cross-Pollination-and-Shared-Capabilities]]

## Decisions

- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0012-post-secondary-digital-commons]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0013-institution-first-federation-locality]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0014-fediverse-social-fabric]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0015-commons-funding-assumption]]

## Delivery and economics

- [[common/psdc-architecture/docs/economics/Post-Secondary-Digital-Commons-Funding-Model]]
- [[common/psdc-architecture/docs/roadmap/Ecosystem-Implementation-Readiness-2026-09-11]]
- [[common/psdc-architecture/docs/governance/Human-Choices-and-Decisions-Register]]

## Deployment logic

Institution experience → reusable tenant-neutral core → explicitly trusted
federation. Placement remains institution-first, then regional, Ontario, Canada,
Canadian commercial providers, and global/external providers only as an approved
last resort.

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **06 - Post-Secondary Commons**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

## Ownership boundaries

The owning repository remains authoritative for each capability. This workspace map may link and summarize, but it MUST NOT redefine a repository contract, institution policy, or signed deployment value.

## Dependency and relationship semantics

Arrows and links represent a declared dependency or navigation relationship, not shared database access. Producers and consumers MUST use the referenced versioned contract; circular synchronous dependencies are prohibited unless an ADR explicitly accepts them.

## Scope and exclusions

The map covers the documents and repositories named in its links. It excludes secrets, private infrastructure values, unapproved vendor commitments, and implementation details that belong in the owning repository.

## Source of truth and references

The source of truth is the linked document in the owning repository plus its accepted ADRs and contracts. Links MUST remain relative inside a repository or use the canonical hosted repository URL when crossing repository boundaries.

## Validation and staleness

The map is valid only when links resolve, referenced documents retain their declared control blocks, and no newer accepted ADR contradicts the summary. Run scripts/Test-Documentation.ps1 and scripts/Test-DocumentQuality.ps1; stale or contradictory entries MUST be corrected or marked historical.
