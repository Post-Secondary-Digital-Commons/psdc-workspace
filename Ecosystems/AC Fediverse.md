---
tags: [ecosystem, fediverse, activitypub]
---

# AC Fediverse

Canonical repository: [[common/psdc-social/README|psdc-social]].

## Owns

Social products, actors, inbox/outbox, discovery, delivery, federation policy,
moderation, abuse response and the public ActivityPub boundary.

## Dependencies

- Hard: Cloud identity/policy/data/object primitives for local operation.
- Optional: Media Fabric for advanced assets, AI for enrichment/moderation, ACF
  for background capacity.
- Rule: text social operation has deterministic fallbacks when optional systems
  are unavailable.

## Links

- [[common/psdc-architecture/docs/vision/constitutional/Fediverse-Platform-Architecture]]
- [[common/psdc-architecture/docs/fediverse/ActivityPub-Architecture]]
- [[common/psdc-architecture/docs/architecture/03-activitypub-federation]]
