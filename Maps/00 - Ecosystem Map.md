---
tags: [moc, ecosystem, architecture]
---

# Ecosystem Map

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
