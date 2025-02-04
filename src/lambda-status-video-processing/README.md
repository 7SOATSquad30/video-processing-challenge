# Upload Lambda

## - Lambda API [Producer]
  - POST /users/{}/videos/process
    - Salva vídeo no S3
    - Enfileira processamento do video
  - GET /users/{}/videos
    - Consulta status dos processamentos

## S3

bucket: fiap-postech-video-processing


{
    "id":"1234567890",
    "userId":"123",
    "videoName":"video1.mp4"
}


curl -X GET http://<REST_API_ID>.execute-api.localhost.localstack.cloud:4566/dev/test

curl -X GET http://localhost:4566/_aws/execute-api/pyptlbcetn/user


aws apigateway create-deployment \
  --rest-api-id pyptlbcetn \
  --stage-name dev


aws apigateway get-resources --rest-api-id pyptlbcetn



 
const isProd = process.env.ENVIRONMENT === 'prod'; 

const dynamoDB = new AWS.DynamoDB.DocumentClient(isProd ? undefined : {
  region: "us-east-1",
  endpoint: "http://localhost:4566", // LocalStack
  accessKeyId: "test",
  secretAccessKey: "test",
});



role aleatória para lambda:
arn:aws:iam::123456789012:role/LambdaExecutionRole




DynamoDB mock example:

{
  "object_key": "000001",
  "userId": "abc",
  "videoName": "teste.mp4",
  "status": "A_PROCESSAR",
  "timestamp": 1738476313601
}

{
  "object_key": "000002",
  "userId": "abc",
  "videoName": "teste.mp4",
  "status": "SUCESSO",
  "timestamp": 1738476313602
}

{
  "object_key": "000003",
  "userId": "abc",
  "videoName": "teste.mp4",
  "status": "ERRO",
  "timestamp": 1738476313603
}
