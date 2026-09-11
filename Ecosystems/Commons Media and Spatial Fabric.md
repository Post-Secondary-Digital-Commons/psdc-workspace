---
tags: [ecosystem, media, spatial]
---

# Commons Media and Spatial Fabric


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

Canonical repository: [[common/psdc-media/README|psdc-media]].

## Owns

Media identity, manifests, provenance, rights, moderation, processing, spatial and
4DGS representations, renditions and delivery.

## Dependencies

- Hard: Cloud identity/policy, PostgreSQL metadata, Ceph object storage and one
  local open-source processing runtime.
- Optional: Commons Compute capacity, AI enrichment and Social Fabric publication.
- Rule: assets remain usable and governed without federation.

## Links

- [[common/psdc-architecture/docs/media/Media-Fabric-Architecture]]
- [[common/psdc-architecture/docs/media/Spatial-Media-Architecture]]
- [[common/psdc-architecture/docs/architecture/Cross-Pollination-and-Shared-Capabilities]]

## Purpose and mapped scope

This map is the workspace navigation view for **Commons Media and Spatial Fabric**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
