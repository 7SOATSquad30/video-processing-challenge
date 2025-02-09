import { getConfigs } from "./config";

import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, QueryCommand } from "@aws-sdk/lib-dynamodb";
import { UserData } from "./model";
import jwt from 'jsonwebtoken';

const configs = getConfigs();

const dynamoClient = new DynamoDBClient(configs.dynamo.client);
const documentClient = DynamoDBDocumentClient.from(dynamoClient);

exports.handler = async (event: any) => {
  console.log('event', event);

  const token = event.headers.Authorization.split(" ")[1];
  const userData = <UserData | undefined> jwt.decode(token, { complete: true })?.payload;
  if (!userData?.name || !userData?.email) {
    return {
      statusCode: 401,
      body: JSON.stringify({
        message: 'Invalid token',
      }),
    };
  }

  try {
    const userVideos = await getUserVideos(userData.email);
    console.log('userVideos', userVideos);

    if (!userVideos || userVideos.length === 0) {
      return {
        statusCode: 404,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ error: 'User or videos not found.' }),
      };
    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ videos: userVideos }),
    };
  } catch (error: any) {
    console.error('Error', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ error: 'Internal server error' }),
    };
  }
};

const getUserVideos = async (userId: string) => {
  const query = new QueryCommand({
    TableName: configs.dynamo.tableName,
    KeyConditionExpression: "#userId = :userId",
    ExpressionAttributeNames: { "#userId": "user_id" },
    ExpressionAttributeValues: { ":userId": userId },
  });

  const data = await documentClient.send(query);
  return data.Items;
}
