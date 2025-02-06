import { S3Client } from "@aws-sdk/client-s3";
import { Upload } from "@aws-sdk/lib-storage";
import { getConfigs } from "./config";
import { Readable } from "node:stream";

export type File = {
  name: string;
  data: string | Uint8Array | Buffer | Readable;
  contentType?: string;
};

const configs = getConfigs();

const s3Client = new S3Client(configs.s3.client);

export async function saveFile(file: File, key: string) {
  const upload = new Upload({
    client: s3Client,
    params: {
      Bucket: configs.s3.bucketName,
      Key: key,
      Body: file.data,
      ContentType: file.contentType,
    },
    leavePartsOnError: false,
  });
  
  console.log('Saving file to S3...');
  try {
    await upload.done();
    console.log('Saved file to S3.');
  } catch (error: any) {
    if (error) {
      console.error('Error saving file to S3.', error);
      throw error;
    }
  };
};