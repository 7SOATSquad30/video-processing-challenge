import { PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { getConfigs } from "./config";
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

const configs = getConfigs();

const s3Client = new S3Client(configs.s3.client);

const ONE_HOUR = 3600;

export async function generateSignedUrlForFileUpload(fileKey: string, contentType: string, expiresIn: number = ONE_HOUR) {
  const command = new PutObjectCommand({
    Bucket: configs.s3.bucketName,
    Key: fileKey,
    ContentType: contentType,
  });

  return await getSignedUrl(s3Client, command, { expiresIn });
}