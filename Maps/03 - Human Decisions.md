---
tags: [moc, decision, governance]
---

# Human Decisions


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

The authoritative register is
[[common/psdc-architecture/docs/governance/Human-Choices-and-Decisions-Register|Human Choices and Decisions Register]].

All proposed project defaults are accepted by ADR-0016. The remaining queue is
implementation evidence and external institutional approval, not product-choice
indecision.

## Immediate implementation and approval queue

1. Governance, sponsor and production ownership
2. Complete legal review of Apache-2.0, DCO and participant contribution terms
3. First integrated MVP and pilot population
4. Validate the accepted infrastructure stack on representative campus hardware
5. Keycloak realm/claim model and College-approved Entra adapter
6. Implement the Python/FastAPI gateway and compatibility profile
7. Select the first exact openly licensed model release from hardware evidence
8. Data classification, prompt retention and telemetry rules
9. ACF pilot hardware, worker language and enrollment design
10. Open WebUI v0.6.5 provenance, legal, security, accessibility and maintenance gates
11. Accountable owners for every ecosystem and cross-cutting review area
12. Define the second-institution pilot and federation trust agreement

## Process

- [[common/psdc-architecture/docs/Documentation-Architecture-Standard]]
- [[common/psdc-architecture/docs/architecture/Decision-Traceability-Matrix]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0001-standards-first-buy-borrow-build|ADR-0001]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0008-open-source-self-hosted-core|ADR-0008]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0009-psdc-ai-web-foundation|ADR-0009]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0010-provider-neutral-core-institutional-production-authority|ADR-0010]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0011-terraform-default-with-open-fallback|ADR-0011]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0012-post-secondary-digital-commons|ADR-0012]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0013-institution-first-federation-locality|ADR-0013]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0014-fediverse-social-fabric|ADR-0014]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0015-commons-funding-assumption|ADR-0015]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0016-accept-register-defaults|ADR-0016]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0017-opentofu-default|ADR-0017 Current IaC default]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0022-polyrepo-ecosystem-with-package-workspaces|ADR-0022 Polyrepo ecosystem]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0023-institution-organization-fork-model|ADR-0023 Institution forks]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0024-permissive-license-and-upstream-contribution|ADR-0024 Licensing and contribution]]

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **03 - Human Decisions**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
