const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

const tableName = 'table_videos'; // TODO process.env.tableName;

export async function save(event: any) {
  const item = JSON.parse(event.body);

  const params = {
    TableName: tableName,
    Item: item
  };

  try {
    await dynamoDb.put(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Item inserted successfully' })
    };
  } catch (error: any) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
