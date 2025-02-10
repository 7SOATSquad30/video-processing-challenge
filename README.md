### Pré-requisitos pra rodar local
- docker
- docker-compose

### Como rodar local

Windows:
```
docker-compose up -d
docker exec builder /bin/bash -c "make build"
docker exec builder /bin/bash -c "make deploy/dev"
```

Linux ou MacOS:
```
make infrastructure/up
make build/with-docker
make deploy/dev/with-docker
```

# 
### Postman:
- [Collection](https://raw.githubusercontent.com/7SOATSquad30/video-processing-challenge/refs/heads/main/docs/Hackaton.postman_collection.json)
- [Environment](https://raw.githubusercontent.com/7SOATSquad30/video-processing-challenge/refs/heads/main/docs/Hackaton.postman_environment.json)