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

export async function save(event: any) {
  const item = JSON.parse(event.body);

  const params = {
    TableName: tableName,
    Item: item
  };

  try {
    await dynamoDb.put(params).promise();
    console.log('Item inserted successfully into DynamoDB.');
    // return {
    //   statusCode: 200,
    //   body: JSON.stringify({ message: 'Item inserted successfully into DynamoDB.' })
    // };
  } catch (error: any) {
    console.error('Error inserting item into DynamoDB.', error);
    // return {
    //   statusCode: 500,
    //   body: JSON.stringify({ error: error.message })
    // };
  }
};
