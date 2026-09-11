---
tags: [moc, ecosystem, architecture]
---

# Ecosystem Map


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

```text
        Post-Secondary Digital Commons
     institution experience | neutral core | federation
                               |
                 Algonquin reference deployment
                               |
                    Commons Cloud Fabric
                               |
          +--------------------+--------------------+
          |                    |                    |
 Commons Compute      Commons AI Fabric    Commons Media/Spatial
          |                    |                    |
          +--------------------+--------------------+
                               |
                    Commons Social Fabric
                               |
               spatial context across all systems
                               |
                    ActivityPub federation edge

        Web  <-->  Desktop  <-->  Mobile
          \________ shared client contracts ________/
```

## System notes

- [[Ecosystems/Commons Cloud Fabric]] — identity, policy, data, edge, and operations
- [[Ecosystems/Commons Compute Fabric]] — sovereign campus-resource coordination
- [[Ecosystems/Commons AI Fabric]] — AI APIs, routing, policy, knowledge, and agents
- [[Ecosystems/Commons Media and Spatial Fabric]] — governed media, 3D, and 4DGS
- [[Ecosystems/Commons Social Fabric]] — social products and the ActivityPub boundary
- [[common/psdc-web/README|PSDC Web]] — institution-neutral browser and PWA client
- [[institutions/algonquin/algonquin-web/README|Algonquin Web]] — Algonquin branding and deployment fork
- Academic, Data, Developer, Communications, and Research are logical Commons
  fabrics composed through the five implementation repositories until independent
  ownership or deployment evidence justifies extraction.
- Compute, research, artifact, and service federation use explicit capability
  contracts; ActivityPub remains the public social federation edge.

## Canonical architecture

- [[common/psdc-architecture/docs/architecture/Consolidated-Ecosystem-Architecture]]
- [[common/psdc-architecture/docs/vision/constitutional/PSDC-Platform-Reference-Architecture]]
- [[common/psdc-architecture/docs/vision/04-Platform-Taxonomy]]
- [[common/psdc-architecture/docs/vision/05-Capability-Map]]
- [[common/psdc-architecture/docs/vision/constitutional/Post-Secondary-Digital-Commons-Architecture]]
- [[common/psdc-architecture/docs/architecture/Federated-Commons-Naming-and-Sovereignty]]
- [[common/psdc-web/docs/architecture/Web-Client-Architecture]]

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **00 - Ecosystem Map**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
