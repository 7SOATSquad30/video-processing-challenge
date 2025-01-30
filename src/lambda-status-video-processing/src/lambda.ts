const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

const tableName = 'table_videos'; // TODO process.env.tableName;

exports.handler = async (event: any) => {
  const userId = event.pathParameters.userId;

  const params = {
    TableName: tableName,
    KeyConditionExpression: '#userId = :userId',
    ExpressionAttributeNames: {
      '#userId': 'userId'
    },
    ExpressionAttributeValues: {
      ':userId': userId
    }
  };

  try {
    const data = await dynamoDb.query(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ videos: data.Items })
    };
  } catch (error: any) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
