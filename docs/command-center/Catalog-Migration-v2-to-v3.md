# Repository Catalog Migration: Schema 2 to Schema 3

**Status:** Implemented on `codex/workspace-command-center-20261007`  
**Scope:** Representation change in `repos.yaml`; no repository deletion  
**Authority:** Migration evidence only; it does not create or remove repositories

## Why the red diff looked destructive

Schema 2 stored each common repository and Algonquin fork as a compact pair:

```yaml
- common: { name: psdc-cloud, ... }
  algonquin: { name: algonquin-cloud, ... }
```

Schema 3 stores the same pair as a richer common repository record with an
`institutionOverlays` list. Git therefore shows the old lines as removed and
the new structure as added, even when the identity, path, and remote are
unchanged.

```yaml
- repository:
    id: psdc-cloud
    ...
  institutionOverlays:
    - id: algonquin-cloud
      ...
```

## Preservation proof

All ten schema-2 pairs remain present in schema 3:

| Schema-2 common | Schema-3 common | Schema-2 Algonquin | Schema-3 overlay | Result |
|---|---|---|---|---|
| psdc-architecture | psdc-architecture | algonquin-architecture | algonquin-architecture | Preserved |
| psdc-cloud | psdc-cloud | algonquin-cloud | algonquin-cloud | Preserved |
| psdc-ai | psdc-ai | algonquin-ai | algonquin-ai | Preserved |
| psdc-compute | psdc-compute | algonquin-compute | algonquin-compute | Preserved |
| psdc-media | psdc-media | algonquin-media | algonquin-media | Preserved |
| psdc-social | psdc-social | algonquin-social | algonquin-social | Preserved |
| psdc-web | psdc-web | algonquin-web | algonquin-web | Preserved |
| psdc-desktop | psdc-desktop | algonquin-desktop | algonquin-desktop | Preserved |
| psdc-mobile | psdc-mobile | algonquin-mobile | algonquin-mobile | Preserved |
| psdc-deployment-template | psdc-deployment-template | algonquin-deployment | algonquin-deployment | Preserved |

Schema 3 adds `psdc-agent-skills` and declares `algonquin-agent-skills` as a
**planned** overlay. The generated command center now has an explicit checkout
status column so a planned path cannot be mistaken for a deleted repository.

## Verification

The schema and semantic validator enforce unique common IDs, resolvable
dependencies, and an explicit provider or external boundary for every consumed
interface. The generated online snapshot observed:

- 11 common catalog entries;
- 11 Algonquin overlays;
- zero missing active checkouts; and
- one planned overlay (`algonquin-agent-skills`).

The remote state remains independent of this file. Editing the catalog does not
delete a local directory or a GitHub repository.
