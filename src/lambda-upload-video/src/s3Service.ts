const AWS = require('aws-sdk');

const BUCKET_NAME = "fiap-challenge-terraform-state"; // TODO process.env.bucketName;
const INPUT_DIRECTORY = 'input';

const isProd = process.env.NODE_ENV === 'production';
const localstackEndpoint = process.env.LOCALSTACK_HOSTNAME;

const s3 = new AWS.S3(isProd ? undefined : {
  region: "us-east-1",
  endpoint: `http://${localstackEndpoint}:4566`, // LocalStack
  s3ForcePathStyle: true, // Adicionado para forçar o estilo de caminho
  accessKeyId: "test",
  secretAccessKey: "test",
});


export async function s3Upload(params: any) {
  params.Bucket = BUCKET_NAME;
  params.Key = `${INPUT_DIRECTORY}/${params.videoName}`;
  params.Body = params.body;
  
  console.log('#################################################');
  console.log('Uploading video to S3...');
  await s3.upload(params, (err: any, data: any) => {
    if (err) {
      console.error('Error uploading video to S3.', err);
      // return res.status(500).send(err);
      return err;
    }
  });
  console.log('OK - Video uploaded to S3.');
};