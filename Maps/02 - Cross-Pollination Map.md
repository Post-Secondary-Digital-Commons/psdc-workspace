---
tags: [moc, cross-pollination, integration]
---

# Cross-Pollination Map


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

Cross-pollination applies inside one institution and across explicitly trusted
Commons peers. It shares contracts, conformance tests, bounded capabilities, and
signed references—not unrestricted raw institutional data or transitive trust.

Canonical guide: [[common/psdc-architecture/docs/architecture/Cross-Pollination-and-Shared-Capabilities]].

## Capability exchange

- Commons Compute Fabric supplies compute jobs to AI, Media, Social and Cloud operations.
- Commons AI Fabric supplies inference, agents, accessibility enrichment and semantic analysis.
- Commons Media and Spatial Fabric supplies governed assets, renditions, provenance and spatial media.
- Commons Social Fabric supplies social distribution and ActivityPub federation.
- Commons Cloud Fabric supplies identity, policy, events, data, objects, secrets and telemetry.
- Spatial contracts connect resources, campus places, scenes, events and media
  without creating a universal location database.

## High-value joint work

- AI + Compute: policy-aware local inference and evaluation.
- AI + Media: captions, transcripts, descriptions, tagging and generation.
- Media + Fediverse: one asset pipeline with interoperable publication.
- AI + Academic: course-grounded study and faculty-controlled agents.
- Spatial + all systems: campus navigation, captures, events, topology and privacy.
- Developer platform + all systems: one scoped API and SDK experience.
- Web + Desktop + Mobile: one session, identity, permission, notification,
  accessibility and institution-branding contract across form factors.

## Guardrails

Cross-pollination shares contracts and capabilities, not credentials, private code,
databases, user permissions, or undeclared data purposes.

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **02 - Cross-Pollination Map**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
