# Container Images

## Quick start

```bash
docker run -d --name=atsd \
  -p 8088:8088 -p 8443:8443 -p 8081:8081 -p 8082:8082/udp \
  axibase/atsd:latest
```

## Additional Images

| **Distribution** | **Format** | **Installation Guide** |
| :--- | --- | :---: |
| Docker | official image | [View](docker.md)|
| RedHat Docker | certified image | [View](docker-redhat.md)|
| Kubernetes | official image | [View](https://axibase.com/docs/axibase-collector/installation-on-kubernetes.html)|
