# Container Images

## Quick start

```bash
docker run -d --name=atsd \
  -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  axibase/atsd:latest
```

## Installation Guides

| **Distribution** | **Format** | **Installation Guide** |
| :--- | --- | :---: |
| Docker | [Official](https://hub.docker.com/r/axibase/atsd/) Image | [View](docker.md)|
| RedHat Docker | [Certified](https://access.redhat.com/containers/?tab=overview#/registry.connect.redhat.com/axibase/atsd) Image | [View](docker-redhat.md)|
| Kubernetes | Official Image | [View](https://axibase.com/docs/axibase-collector/installation-on-kubernetes.html)|
| ATSD Sandbox | Official Image | [View](https://github.com/axibase/dockers/tree/atsd-sandbox#atsd-sandbox-docker-image)