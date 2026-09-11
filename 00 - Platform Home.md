---
tags:
  - moc
  - ecosystem
aliases:
  - Post-Secondary Digital Commons Home
---

# Post-Secondary Digital Commons


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

This is the migration-source vault. The canonical workspace is a lightweight
polyrepo coordinator: product source stays in independent Git repositories while
these maps provide Obsidian navigation and cross-links.

## Start here

- [[Maps/00 - Ecosystem Map|Ecosystem map]]
- [[Maps/01 - Dependency Map|Dependency map]]
- [[Maps/02 - Cross-Pollination Map|Cross-pollination map]]
- [[Maps/03 - Human Decisions|Human decisions]]
- [[Maps/04 - Open Source Stack|Open-source stack]]
- [[Maps/05 - Architecture and Contracts|Architecture and contracts]]
- [[Maps/06 - Post-Secondary Commons|Post-Secondary Digital Commons]]

## Ecosystems

These links currently point to the Algonquin reference deployment repositories.
Their shared architectural names are Commons Cloud, Compute, AI, Media and
Spatial, and Social Fabrics.

- [[Ecosystems/Commons Cloud Fabric]]
- [[Ecosystems/Commons Compute Fabric]]
- [[Ecosystems/Commons AI Fabric]]
- [[Ecosystems/Commons Media and Spatial Fabric]]
- [[Ecosystems/Commons Social Fabric]]

## Constitutional documents

- [[common/psdc-architecture/docs/vision/constitutional/PSDC-Platform-Vision-and-Principles|Platform vision and principles]]
- [[common/psdc-architecture/docs/vision/constitutional/PSDC-Platform-Reference-Architecture|Reference architecture]]
- [[common/psdc-architecture/docs/architecture/Consolidated-Ecosystem-Architecture|Consolidated ecosystem architecture]]
- [[common/psdc-architecture/docs/architecture/Federated-Commons-Naming-and-Sovereignty|Naming and sovereignty]]
- [[common/psdc-architecture/docs/architecture/Ecosystem-Dependency-Contract|Ecosystem dependency contract]]
- [[common/psdc-architecture/docs/vision/11-Open-Source-Only-Policy|Open-source-only policy]]
- [[common/psdc-architecture/docs/governance/Human-Choices-and-Decisions-Register|Human choices and decisions register]]
- [[common/psdc-architecture/docs/governance/License-Policy|License policy]]
- [[common/psdc-architecture/docs/governance/Commercial-and-Institutional-Upstream-Contribution-Policy|Upstream contribution policy]]
- [[common/psdc-architecture/docs/architecture/Repository-and-Obsidian-Linking-Model|Repository and Obsidian model]]
- [[common/psdc-architecture/docs/clients/PSDC-Web-Foundation|PSDC Web foundation]]
- [[common/psdc-web/README|PSDC Web repository]]
- [[institutions/algonquin/algonquin-web/README|Algonquin Web deployment repository]]
- [[common/psdc-architecture/docs/clients/OpenWork-Desktop-Client-Foundation|OpenWork desktop foundation]]
- [[common/psdc-architecture/docs/clients/Happy-Mobile-Client-Foundation|Happy mobile foundation]]
- [[common/psdc-architecture/docs/clients/Happy-Ecosystem-Feature-Adoption-Scope|Happy feature adoption scope]]
- [[common/psdc-architecture/docs/clients/Institution-Branded-Client-Distribution-and-Access|Institution-branded client access]]
- [[common/psdc-architecture/docs/fediverse/Federated-Social-Governance-Policy|Federated social governance]]
- [[common/psdc-architecture/docs/vision/constitutional/Post-Secondary-Digital-Commons-Architecture|Post-Secondary Digital Commons architecture]]
- [[common/psdc-architecture/docs/vision/13-Technology-Defaults-and-Alternatives|Technology defaults and alternatives]]
- [[common/psdc-architecture/docs/vision/14-Full-Technology-Stack-and-Open-Source-Alternatives|Full stack and open-source alternatives]]
- [[common/psdc-architecture/docs/economics/Post-Secondary-Digital-Commons-Funding-Model|Commons funding model]]
- [[common/psdc-architecture/docs/roadmap/Ecosystem-Implementation-Readiness-2026-09-11|Implementation readiness]]
- [[common/psdc-architecture/docs/architecture/Documentation-Completion-Audit-2026-09-11|Documentation completion audit]]
- [[common/psdc-web/README|PSDC Web client]]
- [[institutions/algonquin/algonquin-web/README|Algonquin Web client]]

## Working rules

1. The master architecture repository owns cross-system decisions and contracts.
2. Product repositories own domain implementation details.
3. Root maps link; they do not duplicate canonical documents.
4. Core operation is open-source and self-hosted.
5. External institutional systems terminate at adapters; College-approved systems
   remain authoritative for their production domains.
6. Every dependency states contract, owner, failure behavior, and exit path.

## Purpose and mapped scope

This map is the workspace navigation view for **00 - Platform Home**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
