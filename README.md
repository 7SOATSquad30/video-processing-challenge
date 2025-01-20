### Pré-requisitos
- docker
- docker-compose
- terraform
- tflocal

### Como rodar (local)
```
docker-compose up -d
tflocal init
tflocal plan
tflocal apply
```

## - Lambda API [Producer]
  - POST /users/{}/videos/process
    - Salva vídeo no S3
    - Enfileira processamento do video
  - GET /users/{}/videos
    - Consulta status dos processamentos
