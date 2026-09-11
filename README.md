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
published under `Post-Secondary-Digital-Commons`; Algonquin's thin forks are
published under `Algonquin-Digital-Commons`. Every local repository has its
hosted `origin`, and each institution fork tracks the corresponding hosted
common repository as `upstream`.

## GitHub governance baseline

All 19 product and workspace repositories protect `main`: changes require a pull
request, unresolved review conversations block merging, administrators are
covered, and force-pushes and branch deletion are disabled. Shared repositories
also require linear history. Institution forks permit merge commits because a
non-destructive upstream synchronization must preserve both the common and local
overlay histories.

The approval count is temporarily zero because `RedjiJB` is the only confirmed
maintainer. Raise it to one and require code-owner review after a second
authorized maintainer is appointed. Required CI checks will be added after the
self-hosted Woodpecker pipelines exist.

Both organizations use deny-by-default membership: organization membership
grants no repository permission, members cannot create repositories or Pages,
and only `RedjiJB` may update protected `main`. The `Club Members` team has
triage access and the `Maintainers` team has maintain access; neither team can
update protected `main` until explicitly promoted by the governance process.
Secret scanning, push protection, Dependabot security alerts and fixes, private
vulnerability reporting, web commit signoff, and repository-wiki disabling are
active across all 19 repositories.

## Licensing

New PSDC-authored code uses Apache-2.0 by default. Upstream-derived files retain
their original MIT, BSD or other compatible license and notices. Contributions
should be sent upstream, especially improvements developed for commercial use,
but Apache-2.0 cannot legally make that contribution mandatory. See the
architecture repository's licensing policy for the reciprocity alternatives.

The former `C:\Users\jredj\dev\algonquin\Algonquin` checkout remains a migration
and history backup; new implementation belongs in this polyrepo workspace.
