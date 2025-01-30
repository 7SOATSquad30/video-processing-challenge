ZIP_FILE=deployment_package.zip
FFMPEG_URL=https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
S3_BUCKET=ffmpeg-package-for-lambda
FFMPEG_S3_KEY=ffmpeg/ffmpeg-release-amd64-static.zip

LAYER_ZIP=ffmpeg-layer.zip
LAYER_DIR=ffmpeg-layer

ifeq ($(origin AWS_ENDPOINT_URL), undefined)
  AWS_ENDPOINT=
else
  AWS_ENDPOINT=--endpoint-url=$(AWS_ENDPOINT_URL)
endif

.PHONY: build
build:
	@echo "Criando diretórios necessários..."
	rm -rf package
	mkdir -p package/tmp
	@echo "Instalando dependências..."
	pip install --target ./package -r app/requirements.txt
	@echo "Compactando pacote de implantação..."
	cd package && zip -r9 ../$(ZIP_FILE) .
	zip -g $(ZIP_FILE) app/lambda_function.py app/src/**/*
	@echo "Pacote de implantação criado: $(ZIP_FILE)"

.PHONY: build-ffmpeg-layer
build-ffmpeg-layer:
	@echo "Baixando FFmpeg..."
	curl -L $(FFMPEG_URL) -o ffmpeg-release-amd64-static.tar.xz
	@echo "Extraindo FFmpeg..."
	mkdir -p $(LAYER_DIR)/bin
	tar -xJf ffmpeg-release-amd64-static.tar.xz --strip-components=1 -C $(LAYER_DIR)/bin
	@echo "Compactando camada FFmpeg..."
	cd $(LAYER_DIR) && zip -r9 ../$(LAYER_ZIP) .
	@echo "Enviando camada FFmpeg para o S3..."
	aws $(AWS_ENDPOINT) s3 cp $(LAYER_ZIP) s3://$(S3_BUCKET)/$(FFMPEG_S3_KEY)
	@echo "FFmpeg Layer enviada para o S3: s3://$(S3_BUCKET)/$(FFMPEG_S3_KEY)"

.PHONY: clean
clean:
	@echo "Limpando arquivos temporários..."
	rm -rf package $(ZIP_FILE) $(LAYER_DIR) $(LAYER_ZIP) ffmpeg-release-amd64-static.tar.xz
	@echo "Limpeza concluída."
