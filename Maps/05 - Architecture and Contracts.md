---
tags: [moc, architecture, contracts]
---

# Architecture and Contracts


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

## Architecture

- [[common/psdc-architecture/docs/architecture/Consolidated-Ecosystem-Architecture]]
- [[common/psdc-architecture/docs/architecture/Federated-Commons-Naming-and-Sovereignty]]
- [[common/psdc-architecture/docs/architecture/System-Context]]
- [[common/psdc-architecture/docs/architecture/Logical-Architecture]]
- [[common/psdc-architecture/docs/architecture/API-Architecture]]
- [[common/psdc-architecture/docs/architecture/Event-Driven-Architecture]]
- [[common/psdc-architecture/docs/architecture/Ecosystem-Dependency-Contract]]
- [[common/psdc-architecture/docs/architecture/Cross-Pollination-and-Shared-Capabilities]]
- [[common/psdc-architecture/docs/architecture/Documentation-Completion-Audit-2026-09-11]]
- [[common/psdc-architecture/docs/vision/constitutional/Post-Secondary-Digital-Commons-Architecture]]
- [[common/psdc-architecture/docs/roadmap/Ecosystem-Implementation-Readiness-2026-09-11]]
- [[common/psdc-web/docs/architecture/Web-Client-Architecture]]
- [[common/psdc-architecture/docs/fediverse/Federated-Social-Governance-Policy]]
- [[common/psdc-architecture/docs/clients/Institution-Branded-Client-Distribution-and-Access]]

## Shared Contracts

- [[common/psdc-architecture/contracts/README|Shared contract catalog]]
- [[common/psdc-architecture/contracts/identity/README|Identity provider contract]]
- [[common/psdc-architecture/contracts/academic/README|Academic provider contract]]
- [[common/psdc-architecture/contracts/agent-sessions/README|Agent session contract]]
- [[common/psdc-architecture/contracts/deployment/README|Institution deployment contract]]
- Events · ActivityPub · spatial · AI · compute · media

## Standards and decisions

- [[common/psdc-architecture/docs/vision/02-Architecture-Principles]]
- [[common/psdc-architecture/docs/vision/06-Reference-Technologies]]
- [[common/psdc-architecture/docs/architecture/Standards-First-Coverage-Matrix]]
- [[common/psdc-architecture/docs/architecture/Source-Decision-Import-2026-09-10]]
- [[common/psdc-architecture/docs/architecture/Source-Decision-Import-2026-09-10-Web-and-Adapters]]
- [[common/psdc-architecture/docs/architecture/Source-Decision-Import-2026-09-10-Commons-Expansion]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0009-psdc-ai-web-foundation|ADR-0009 Web foundation]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0010-provider-neutral-core-institutional-production-authority|ADR-0010 Production authorities]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0011-terraform-default-with-open-fallback|ADR-0011 Superseded Terraform choice]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0017-opentofu-default|ADR-0017 OpenTofu default]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0012-post-secondary-digital-commons|ADR-0012 Digital Commons]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0013-institution-first-federation-locality|ADR-0013 Locality and federation]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0014-fediverse-social-fabric|ADR-0014 Social Fabric]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0015-commons-funding-assumption|ADR-0015 Funding assumption]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0016-accept-register-defaults|ADR-0016 Accepted defaults]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0018-openwork-desktop-client|ADR-0018 OpenWork desktop foundation]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0019-happy-mobile-client|ADR-0019 Happy mobile foundation]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0020-post-secondary-digital-commons-name|ADR-0020 Shared platform name]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0021-institution-branded-client-access|ADR-0021 Institution-branded client access]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0022-polyrepo-ecosystem-with-package-workspaces|ADR-0022 Polyrepo ecosystem]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0023-institution-organization-fork-model|ADR-0023 Institution organization forks]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0024-permissive-license-and-upstream-contribution|ADR-0024 Permissive licensing]]

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **05 - Architecture and Contracts**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
