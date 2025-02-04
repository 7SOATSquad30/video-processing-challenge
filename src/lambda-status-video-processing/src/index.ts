const AWS = require('aws-sdk');

// const dynamoDb = new AWS.DynamoDB.DocumentClient();
const tableName = 'table_videos'; // TODO process.env.tableName;

const isProd = process.env.NODE_ENV === 'production';

const localstackEndpoint = process.env.LOCALSTACK_HOSTNAME;

const dynamoDb = new AWS.DynamoDB.DocumentClient(isProd ? undefined : {
  region: "us-east-1",
  endpoint: `http://${localstackEndpoint}:4566`, // LocalStack
  accessKeyId: "test",
  secretAccessKey: "test",
});

exports.handler = async (event: any) => {
  console.log('event', event);

  try {
    const userId = event?.pathParameters?.userId || event?.userId;
    if (!userId) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ error: 'Field usedId is required.' })
      };
    }

    const params = {
      TableName: tableName,
      IndexName: "TimestampIndex",
      ScanIndexForward: true, // ascendent order
      KeyConditionExpression: "#userId = :userId",
      ExpressionAttributeNames: {
        "#userId": "userId"
      },
      ExpressionAttributeValues: {
        ":userId": "" + userId
      }
    };
    
    console.log('params', params);

    const data = await dynamoDb.query(params).promise();
    console.log('data', data);

    if (!data.Items || data.Items.length === 0) {
      return {
        statusCode: 404,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ error: 'User or videos not found.' })
      };
    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ videos: data.Items })
    };
  } catch (error: any) {
    console.error('Error', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ error: error.message })
    };
  }
};
