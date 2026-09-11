---
tags: [moc, dependency, architecture]
---

# Dependency Map

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
