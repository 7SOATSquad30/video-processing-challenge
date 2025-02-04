infrastructure/up:
	docker-compose up --build -d

infrastructure/down:
	docker-compose down --remove-orphans

deploy/dev:
	docker exec -it builder /bin/bash -c "\
		tflocal -chdir='./src/infra/tfstate' init -backend-config='force_path_style=true' && \
		tflocal -chdir='./src/infra/tfstate' apply -auto-approve && \
		tflocal -chdir='./src/infra/shared' init -backend-config='force_path_style=true' && \
		tflocal -chdir='./src/infra/shared' apply -auto-approve && \
		make -C ./src/lambda-video-processing build && \
		make -C ./src/lambda-video-processing build-ffmpeg-layer && \
		tflocal -chdir='./src/infra/lambda-video-processing' init -backend-config='force_path_style=true' && \
		tflocal -chdir='./src/infra/lambda-video-processing' apply -auto-approve && \
		make -C ./src/lambda-upload-video build && \
		tflocal -chdir='./src/infra/lambda-upload-video' init -backend-config='force_path_style=true' && \
		tflocal -chdir='./src/infra/lambda-upload-video' apply -auto-approve && \
		make -C ./src/lambda-status-video-processing build && \
		tflocal -chdir='./src/infra/lambda-status-video-processing' init -backend-config='force_path_style=true' && \
		tflocal -chdir='./src/infra/lambda-status-video-processing' apply -auto-approve"

infrastructure/logs:
	docker-compose logs -f

application/logs:
	aws --endpoint-url=http://localhost:4566 logs tail /aws/lambda/LambdaProcessadorVideos --follow

lambda-status/logs:
	aws --endpoint-url=http://localhost:4566 logs tail /aws/lambda/lambda-status-video-processing --follow

lambda-upload/logs:
	aws --endpoint-url=http://localhost:4566 logs tail /aws/lambda/lambda-upload-video --follow
	
clear:
	rm -rf .localstack-data/*
