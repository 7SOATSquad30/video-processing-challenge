infrastructure/up:
	docker-compose up -d
	export AWS_ENDPOINT_URL="http://localhost:4566" \
	export AWS_ACCESS_KEY_ID=test \
	export AWS_SECRET_ACCESS_KEY=test

	tflocal -chdir="./src/infra/tfstate" init -backend-config="force_path_style=true"
	tflocal -chdir="./src/infra/tfstate" apply -auto-approve

	tflocal -chdir="./src/infra/shared" init -backend-config="force_path_style=true"
	tflocal -chdir="./src/infra/shared" apply -auto-approve

infrastructure/down:
	docker-compose down --remove-orphans

deploy/dev:
	make -C ./src/lambda-video-processing build
	make -C ./src/lambda-video-processing build-ffmpeg-layer

	tflocal -chdir="./src/infra/lambda-video-processing" init -backend-config="force_path_style=true"
	tflocal -chdir="./src/infra/lambda-video-processing" apply -auto-approve

	make -C ./src/lambda-upload-video build

	tflocal -chdir="./src/infra/lambda-upload-video" init -backend-config="force_path_style=true"
	tflocal -chdir="./src/infra/lambda-upload-video" apply -auto-approve

	make -C ./src/lambda-status-video-processing build

	tflocal -chdir="./src/infra/lambda-status-video-processing" init -backend-config="force_path_style=true"
	tflocal -chdir="./src/infra/lambda-status-video-processing" apply -auto-approve

infrastructure/logs:
	docker-compose logs -f

application/logs:
	aws --endpoint-url=http://localhost:4566 logs tail /aws/lambda/LambdaProcessadorVideos --follow
	