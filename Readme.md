# DockerCluster

A production-ready container cluster deployment solution with built-in support for MinIO, Nginx, Redis, Nacos, PostgreSQL, and more.


## Structure

```
DockyCluster/
├── minio-cluster/           # MinIO deployment
├── nginx-cluster/           # Nginx deployment
├── redis-cluster/           # Redis deployment
├── nacos-cluster/           # Nacos deployment
├── postgresql-cluster/      # PostgreSQL deployment
├── lb1                      # Load balancer 1
├── lb2                      # Load balancer 2
├── .env.example            # Environment template
└── README.md               # Documentation
```

## Quick Start

```bash
cd XXX-cluster/
cp .env.example .env
docker-compose up -d
```

