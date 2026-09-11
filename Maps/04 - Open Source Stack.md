---
tags: [moc, open-source, technology]
---

# Open Source Stack


> Standard: PSDC-DOC-001
> Document type: architecture-map
> Status: Normative
> Owner: Workspace Maintainers
> Accountable maintainer: RedjiJB until delegation
> Last reviewed: 2026-09-11
> Governing decisions: Applicable ADRs and repository governance

## Governing documents

- [[common/psdc-architecture/docs/vision/11-Open-Source-Only-Policy]]
- [[common/psdc-architecture/docs/vision/12-Open-Source-Reference-Stack]]
- [[common/psdc-architecture/docs/vision/13-Technology-Defaults-and-Alternatives]]
- [[common/psdc-architecture/docs/vision/14-Full-Technology-Stack-and-Open-Source-Alternatives|Full stack and OSS alternatives]]
- [[common/psdc-architecture/docs/vision/07-Build-vs-Adopt-vs-Fork]]
- [[common/psdc-architecture/docs/vision/08-Standards-Compatibility-Matrix]]
- [[common/psdc-architecture/docs/governance/License-Policy]]
- [[common/psdc-architecture/docs/governance/Commercial-and-Institutional-Upstream-Contribution-Policy]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0008-open-source-self-hosted-core]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0009-psdc-ai-web-foundation]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0018-openwork-desktop-client]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0019-happy-mobile-client]]
- [[common/psdc-architecture/docs/architecture/architecture-decision-records/ADR-0024-permissive-license-and-upstream-contribution]]
- [[common/psdc-architecture/docs/clients/PSDC-Web-Foundation|PSDC Web foundation]]
- [[common/psdc-architecture/docs/clients/OpenWork-Desktop-Client-Foundation]]
- [[common/psdc-architecture/docs/clients/Happy-Mobile-Client-Foundation]]

## Baseline

Debian · KVM/QEMU · Kubernetes-first · conditional OpenStack · Cilium · Ceph · PostgreSQL ·
Valkey · Keycloak · OpenBao · OPA · NATS · OpenTofu · Ansible · Argo CD ·
Harbor · Forgejo · OpenTelemetry · Prometheus · Grafana/Loki/Tempo/Jaeger · vLLM ·
SGLang · llama.cpp · HTCondor · FFmpeg · GStreamer

Client foundations add the OpenWork MIT core outside `ee/` for desktop and the
Happy MIT Expo/React Native baseline for mobile. Both are gated downstreams:
OpenWork Den/EE/hosted services are excluded, and cross-device operation uses the
institution-controlled, content-blind E2EE Commons Session Relay.

Commons AI Web begins from the verified Open WebUI v0.6.5 BSD source as a
frozen scaffold. Current Open WebUI releases are compatibility-only; later source
cannot be merged without a new license review and ADR.

The project defaults are accepted in ADR-0016. Alternatives remain documented as
evaluated exit paths rather than co-defaults. OpenTofu is the MPL-2.0 IaC default
under ADR-0017, with institution-controlled state. No mandatory SaaS or
proprietary cloud control plane is part of the core. New PSDC-authored material
uses Apache-2.0; upstream-derived files retain their original licenses.

## Obsidian note

Obsidian is an optional editor. Markdown and Git are canonical, so this vault stays
usable with open-source editors and ordinary repository tooling.

Back to [[00 - Platform Home]].

## Purpose and mapped scope

This map is the workspace navigation view for **04 - Open Source Stack**. It identifies relationships among the institution-neutral Commons repositories, institution overlays, and the Obsidian knowledge graph; it is not an implementation contract by itself.

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
