import { HeadObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { getConfigs } from "./config";

const configs = getConfigs();

const s3Client = new S3Client(configs.s3.client);

export async function validateVideoWasUploaded(key: string) {
  try {
    const command = new HeadObjectCommand({
      Bucket: configs.s3.bucketName,
      Key: key,
    });

    const response = await s3Client.send(command);

    return response ? true : false;
  } catch (error: any) {
    if (error.name === "NoSuchKey") {
      return false;
    }
    throw error;
  }
};
