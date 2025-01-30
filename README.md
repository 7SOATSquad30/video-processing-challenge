### Pré-requisitos pra rodar local
- docker
- docker-compose
- terraform
- tflocal

### Como rodar local

Windows:
```
docker-compose up -d
export AWS_ENDPOINT_URL="http://localhost:4566"
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test

tflocal -chdir="./src/infra/tfstate" init -backend-config="force_path_style=true"
tflocal -chdir="./src/infra/tfstate" apply

tflocal -chdir="./src/infra/shared" init -backend-config="force_path_style=true"
tflocal -chdir="./src/infra/shared" apply

make -C ./src/lambda-video-processing build
make -C ./src/lambda-video-processing build-ffmpeg-layer

tflocal -chdir="./src/infra/lambda-video-processing" init -backend-config="force_path_style=true"
tflocal -chdir="./src/infra/lambda-video-processing" apply

docker-compose logs -f
```

Linux ou MacOS:
```
make infrastructure/up
make deploy/dev
make logs
```