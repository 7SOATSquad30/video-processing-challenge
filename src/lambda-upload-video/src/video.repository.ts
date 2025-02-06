import { getConfigs } from "./config";

import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";
import { Video } from "./model";

const configs = getConfigs();

const dynamoClient = new DynamoDBClient(configs.dynamo.client);
const documentClient = DynamoDBDocumentClient.from(dynamoClient);

export async function saveVideo(video: Video) {
  try {
    const saveCommand = new PutItemCommand({
      TableName: configs.dynamo.tableName,
      Item: {
        "user_id": {
          S: video.userId,
        },
        "video_id": {
          S: video.videoId,
        },
        "status": {
          S: video.status,
        },
        "s3_object_key": {
          S: video.s3ObjectKey,
        },
        "timestamp": {
          N: video.timestamp?.toString(),
        }
      }
    });
    await documentClient.send(saveCommand);
    console.log('Video saved successfully');
  } catch (error: any) {
    console.error('Error saving video', error);
  }
};
