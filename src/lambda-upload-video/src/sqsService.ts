const AWS = require('aws-sdk');

const isProd = process.env.NODE_ENV === 'production';
const localstackEndpoint = process.env.LOCALSTACK_HOSTNAME;

const sqs = new AWS.SQS(isProd ? undefined : {
  region: "us-east-1",
  endpoint: `http://${localstackEndpoint}:4566`, // LocalStack
  accessKeyId: "test",
  secretAccessKey: "test",
});

const queueUrl = isProd ? process.env.queueUrl : `http://${localstackEndpoint}:4566/000000000000/sqs-processamento-video`;

export async function sqsSendMessage(params: any) {
  try {
    const data = {
      QueueUrl: queueUrl,
      MessageBody: JSON.stringify(params)
    };
    const result = await sqs.sendMessage(data).promise();
    console.log('Message sent successfully.', result);
    return result;
  } catch (error: any) {
    console.error('Error sending message.', error);
  }
};
