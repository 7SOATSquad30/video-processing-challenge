import { getConfigs } from "./config";

import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, QueryCommand } from "@aws-sdk/lib-dynamodb";

const configs = getConfigs();

const dynamoClient = new DynamoDBClient(configs.dynamo.client);
const documentClient = DynamoDBDocumentClient.from(dynamoClient);

export const getUserVideos = async (userId: string) => {
    const query = new QueryCommand({
      TableName: configs.dynamo.tableName,
      KeyConditionExpression: "#userId = :userId",
      ExpressionAttributeNames: { "#userId": "user_id" },
      ExpressionAttributeValues: { ":userId": userId },
    });
  
    const data = await documentClient.send(query);
    return data.Items;
  }