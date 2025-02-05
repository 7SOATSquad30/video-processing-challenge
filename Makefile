infrastructure/up:
	docker-compose up --build -d

infrastructure/down:
	docker-compose down --remove-orphans

build/with-docker:
	docker exec -it builder /bin/bash -c "make build"

build:
	make -C ./src/lambda-video-processing build-ffmpeg-layer && \
	make -C ./src/lambda-video-processing build && \
	make -C ./src/lambda-upload-video build && \
	make -C ./src/lambda-status-video-processing build

deploy/dev/with-docker:
	docker exec -it builder /bin/bash -c "make deploy/dev"

deploy/dev:
	tflocal -chdir='./src/infra/shared' init \
		-backend-config='force_path_style=true' && \
	tflocal -chdir='./src/infra/shared' apply \
		-auto-approve \
		-var='ses_domain_identity_name=7soat.fiap.example' \
		-var='ses_email_address=7soat@fiap.example'

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
