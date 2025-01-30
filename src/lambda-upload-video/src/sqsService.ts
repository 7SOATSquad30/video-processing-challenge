const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

const queueUrl = 'sqs-processamento-video'; // TODO process.env.queueUrl;

export async function addMessage(event: any) {
  const messageBody = JSON.parse(event.body).message;

  const params = {
    QueueUrl: queueUrl,
    MessageBody: messageBody
  };

  try {
    const data = await sqs.sendMessage(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Message sent successfully', data })
    };
  } catch (error: any) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
