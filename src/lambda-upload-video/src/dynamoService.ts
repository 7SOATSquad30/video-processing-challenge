const AWS = require('aws-sdk');

const tableName = 'table_videos'; // TODO process.env.tableName;
const isProd = process.env.NODE_ENV === 'production';
const localstackEndpoint = process.env.LOCALSTACK_HOSTNAME;

const dynamoDb = new AWS.DynamoDB.DocumentClient(isProd ? undefined : {
  region: "us-east-1",
  endpoint: `http://${localstackEndpoint}:4566`, // LocalStack
  accessKeyId: "test",
  secretAccessKey: "test",
});

export async function dynamoCreate(params: any) {
  try {
    const data = {
      TableName: tableName,
      Item: params.body
    };
    await dynamoDb.put(data).promise();
    console.log('Item inserted successfully into DynamoDB.');
  } catch (error: any) {
    console.error('Error inserting item into DynamoDB.', error);
  }
};
