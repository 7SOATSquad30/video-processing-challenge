# Upload Lambda

## - Lambda API [Producer]
  - POST /users/{userId}/videos/process
    - Salva vídeo no S3
    - Enfileira processamento do video
  - GET /users/{userId}/videos
    - Consulta status dos processamentos

## S3

bucket: fiap-postech-video-processing
