import { SendMessageCommand, SQSClient } from "@aws-sdk/client-sqs";
import { getConfigs } from "./config";
import { Video } from "./model";

const configs = getConfigs();

const sqsClient = new SQSClient(configs);

export async function notifyNewVideoToBeProcessed(video: Video) {
  try {
    const message = new SendMessageCommand({
      QueueUrl: configs.sqs.queueUrl,
      MessageBody: JSON.stringify(video),
    });
    const result = await sqsClient.send(message);
    console.log('Notified video to be processed.', result);
    return result;
  } catch (error: any) {
    console.error('Error notifying video to be processed.', error);
  }
};
