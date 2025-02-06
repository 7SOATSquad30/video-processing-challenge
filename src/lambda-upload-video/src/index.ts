import { Video, VideoProcessingStatus } from "./model";
import { File, saveFile } from "./storage.service";
import { saveVideo } from "./video.repository";
import { notifyNewVideoToBeProcessed } from "./messaging.service";

import busboy from 'busboy';
import { PassThrough } from 'node:stream';

exports.handler = async (event: any) => {
    try {
        console.log('Event:', event);
        
        const userId = event?.pathParameters?.userId || event?.userId;
        if (!userId) {
          return {
            statusCode: 400,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: 'Field usedId is required.' })
          };
        }

        const contentType = event.headers?.["Content-Type"] || event.headers?.["content-type"];
        if (!contentType?.startsWith("multipart/form-data")) {
          return {
            statusCode: 400,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ message: "Invalid Content-Type" })
          };
        }

        let body = event.body;
        if (event.isBase64Encoded) {
            body = Buffer.from(event.body, 'base64');
        }

        event.headers['content-type'] = contentType;
        const bb = busboy({ headers: event.headers });
        const fileDataStream = new PassThrough();
        let fileName: string;

        console.log('Receiving file...');
        const promise = new Promise((resolve: any, reject: any) => {
            bb.on("file", (_fieldName: any, file: any, fileParams: any, _encoding: any, _mimetype: any) => {
              fileName = fileParams.filename;
              file.pipe(fileDataStream);
              file.on("end", () => console.log(`Finished receiving file: ${fileParams.filename}`));
            });
            bb.on("error", (err: any) => reject(err));
            bb.on("finish", () => resolve());
        });

        bb.end(body);
        await promise;

        const file: File = {
          name: fileName!,
          data: fileDataStream,
        }

        const uploadTimestamp = new Date().getTime();
        const video: Video = {
          userId,
          videoId: uploadTimestamp.toString(),
          status: VideoProcessingStatus.ENQUEUED,
          s3ObjectKey: `input/${userId}_${uploadTimestamp}_${file.name}`,
          timestamp: uploadTimestamp,
        }

        await saveFile(file, video.s3ObjectKey);
        await saveVideo(video);
        await notifyNewVideoToBeProcessed(video);

        const message = `File ${file.name} was uploaded for user ${userId}.`;
        console.log(message);

        return {
            statusCode: 200,
            body: JSON.stringify({ message })
        };
    } catch (error: any) {
      console.error('Error', error);
      return {
          statusCode: 500,
          body: JSON.stringify({ message: "Erro ao processar upload do video.", error: error.message })
      };
    }
};
