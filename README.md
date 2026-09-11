# PSDC Multi-Organization Workspace

This Git repository coordinates local checkouts and Obsidian navigation. It does
not contain product source. Every directory under `common/` and
`institutions/algonquin/` is an independent Git repository ignored by this
workspace repository.

## Organization topology

```text
psdc/
├── common/                         Commons GitHub organization checkouts
│   ├── psdc-architecture/
│   ├── psdc-cloud/
│   ├── psdc-ai/
│   ├── psdc-compute/
│   ├── psdc-media/
│   ├── psdc-social/
│   ├── psdc-desktop/
│   ├── psdc-mobile/
│   └── psdc-deployment-template/
└── institutions/
    └── algonquin/                  Algonquin GitHub organization forks
        ├── algonquin-architecture/
        ├── algonquin-cloud/
        ├── algonquin-ai/
        ├── algonquin-compute/
        ├── algonquin-media/
        ├── algonquin-social/
        ├── algonquin-desktop/
        ├── algonquin-mobile/
        └── algonquin-deployment/
```

GitHub forks repositories, not organizations. Each Algonquin repository therefore
tracks one Commons repository as `upstream`; its Algonquin GitHub repository will
be `origin`. Other universities repeat the same mapping in their own organization.

White-labelling is implemented by a thin institution fork plus the forked
deployment template, signed deployment manifest, branding and policy adapters.
Reusable improvements are proposed upstream to the owning Commons repository.
Institution forks must not create incompatible private contracts or copy sibling
source.

`repos.yaml` is the checkout and fork inventory. The neutral repositories are
published under `Post-Secondary-Digital-Commons` and their local `origin`
remotes are configured. The Algonquin organization slug and hosted fork URLs
remain unset until the intended organization is confirmed.

## Licensing

New PSDC-authored code uses Apache-2.0 by default. Upstream-derived files retain
their original MIT, BSD or other compatible license and notices. Contributions
should be sent upstream, especially improvements developed for commercial use,
but Apache-2.0 cannot legally make that contribution mandatory. See the
architecture repository's licensing policy for the reciprocity alternatives.

The former `C:\Users\jredj\dev\algonquin\Algonquin` checkout remains a migration
and history backup; new implementation belongs in this polyrepo workspace.
