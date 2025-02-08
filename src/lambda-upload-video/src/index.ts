import { Video, VideoProcessingStatus } from "./model";
import { File, saveFile } from "./storage.service";
import { saveVideo } from "./video.repository";
import { notifyNewVideoToBeProcessed } from "./messaging.service";

import busboy from 'busboy';

exports.handler = async (event: any) => {
    try {
        console.log('Event:', event);
        
        const userId = event?.pathParameters?.userId || event?.userId;
        if (!userId) {
          return {
            statusCode: 400,
            body: JSON.stringify({ error: 'Field usedId is required.' })
          };
        }

        const contentType = event.headers?.["Content-Type"] || event.headers?.["content-type"];
        if (!contentType?.startsWith("multipart/form-data")) {
          return {
            statusCode: 400,
            body: JSON.stringify({ message: "Invalid Content-Type" })
          };
        }

        let body = event.body;
        if (event.isBase64Encoded) {
            body = Buffer.from(event.body, 'base64');
        }

        event.headers['content-type'] = contentType;
        const bb = busboy({ headers: event.headers });

        let fileName: string;
        let fileMimeType: string;
        const chunks: Buffer[] = [];

        const promise = new Promise((resolve, reject) => {
          bb.on("file", (_fieldName: string, file: NodeJS.ReadableStream, fileParams: Record<string, unknown>, _encoding: string, mimetype: string) => {
            fileName = <string> fileParams.filename;
            fileMimeType = mimetype;

            file.on("data", (chunk: Buffer<ArrayBufferLike>) => chunks.push(chunk));
            file.on("end", () => console.log(`Finished receiving file: ${fileParams.filename}`));
          });

          bb.on("error", reject);
          bb.on("finish", resolve);
        });

        bb.end(body);
        await promise;

        const fileBuffer = Buffer.concat(chunks);

        const uploadTimestamp = new Date().getTime();
        const file: File = {
          name: fileName!,
          contentType: fileMimeType!,
          data: fileBuffer,
        }
        const video: Video = {
          userId,
          videoId: uploadTimestamp.toString(),
          status: VideoProcessingStatus.ENQUEUED,
          s3ObjectKey: `${userId}_${uploadTimestamp}_${fileName!}`,
          timestamp: uploadTimestamp,
        };

        await saveFile(file, video.s3ObjectKey);
        await saveVideo(video);
        await notifyNewVideoToBeProcessed(video);

        return {
          statusCode: 200,
          body: JSON.stringify({ message: `File ${fileName!} was uploaded for user ${userId}.` })
        };
    } catch (error: any) {
        console.error('Error', error);
        return {
          statusCode: 500,
          body: JSON.stringify({ message: "Error processing video upload.", error: error.message })
        };
    }
};
