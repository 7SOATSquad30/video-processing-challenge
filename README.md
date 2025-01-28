### Pré-requisitos pra rodar local
- docker
- docker-compose

### Como rodar local

Windows:
```
docker-compose up -d

docker exec -it builder /bin/bash -c "\
	tflocal -chdir='./src/infra/tfstate' init -backend-config='force_path_style=true' && \
	tflocal -chdir='./src/infra/tfstate' apply -auto-approve && \
	tflocal -chdir='./src/infra/shared' init -backend-config='force_path_style=true' && \
	tflocal -chdir='./src/infra/shared' apply -auto-approve && \
	make -C ./src/lambda-video-processing build && \
	make -C ./src/lambda-video-processing build-ffmpeg-layer && \
	tflocal -chdir='./src/infra/lambda-video-processing' init -backend-config='force_path_style=true' && \
	tflocal -chdir='./src/infra/lambda-video-processing' apply -auto-approve \
"
```

Linux ou MacOS:
```
make infrastructure/up
make deploy/dev
```