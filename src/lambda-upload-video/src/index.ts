const AWS = require('aws-sdk');
const busboy = require('busboy');
const fs = require('fs');
const path = require('path');

import { s3Upload } from './s3Service';
import { dynamoCreate } from './dynamoService';
import { sqsSendMessage } from './sqsService';

exports.handler = async (event: any) => {
    try {
        console.log('Event:', event);
        const userId = event?.pathParameters?.userId || event?.userId;
        const contentType = event.headers?.["Content-Type"] || event.headers?.["content-type"];

        const params: any = {
          userId,
          timestamp: new Date().getTime(),
          contentType
        };

        if (!userId) {
          return {
            statusCode: 400,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: 'Field usedId is required.' })
          };
        }

        if (!contentType?.startsWith("multipart/form-data")) {
            return {
                statusCode: 400,
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ message: "Invalid Content-Type" })
            };
        }

        event.headers['content-type'] = contentType;
        const bb = busboy({ headers: event.headers });
        const fileData: any = [];

        console.log('#################################################');
        console.log('Receiving file...');
        const promise = new Promise((resolve: any, reject: any) => {
            bb.on("file", (fieldname: any, file: any, fileParams: any, encoding: any, mimetype: any) => {
              params.filename = fileParams.filename;
              file.on("data", (data: any) => fileData.push(data));
              file.on("end", () => console.log(`Finished receiving file: ${fileParams.filename}`));
            });
            bb.on("error", (err: any) => reject(err));
            bb.on("finish", () => resolve());
        });

        bb.end(Buffer.from(event.body));
        await promise;
        
        params.key = `${userId}_${params.timestamp}_${params.filename.split('.')[0]}`;
        params.videoName = `${userId}_${params.timestamp}_${params.filename}`;
        params.body = Buffer.concat(fileData);
        console.log('Params:', JSON.stringify(params));
        
        console.log('#################################################');
        console.log('Uploading file to S3 bucket...');
        await uploadToS3(params);

        console.log('#################################################');
        console.log('Saving data in DynamoDB...');
        await persist(params);

        console.log('#################################################');
        console.log('Adding message in SQS...');
        await addToQueue(params);

        const message = `File ${params.videoName} was uploaded from user ${params.userId}.`;

        console.log('#################################################');
        console.log('Finished!');
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


async function uploadToS3(params: any) {
  try {
    console.log('S3 Params:', params);
    await s3Upload(params);
    console.log('S3 OK - File uploaded to S3.');
  } catch (error: any) {
    console.error('S3 Error', error);
    return error;
  }
}

async function persist(params: any) {
  try {
    await dynamoCreate({
      body: {
        object_key: params.key,
        userId: params.userId,
        videoName: params.videoName,
        timestamp: params.timestamp,
        status: 'A_PROCESSAR'
      }
    });
    console.log('DynamoDB OK - Data saved in DynamoDB.');
  } catch (error: any) {
    console.error('DynamoDB Error', error);
    return error;
  }
}

async function addToQueue(params: any) {
  try {
    await sqsSendMessage({
      object_key: params.key,
      userId: params.userId,
      videoName: params.videoName
    });
    console.log('SQS OK - Message added to SQS.');
  } catch (error: any) {
    console.error('SQS Error', error);
    return error;
  }
}
