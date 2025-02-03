const AWS = require('aws-sdk');
const serverless = require('serverless-http');

import express from 'express';
import multer from 'multer';
import { storage } from './multerConfig';
import fs from 'fs';

import { save } from './dynamoService';
import { addMessage } from './sqsService';

const upload = multer({ storage });

const app = express();

const s3 = new AWS.S3();

const bucket_name = "fiap-challenge-terraform-state"; // TODO process.env.bucketName;
const inputDirectory = 'input';

app.post('/users/:userId/videos/process', upload.single('file'), async (req: any, res: any) => {
  console.log('req', req);
  
  try {
    const timestamp = new Date().getTime();
    const userId = req.params.userId;

    if (!userId) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ error: 'Field usedId is required.' })
      };
    }

    if (!req.file) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ error: 'No video file in the request.' })
      };
    }
    
    const file = req.file;
    const videoName = `${userId}_${timestamp}_${file.originalname}`;
    const params = {
      Bucket: bucket_name,
      Key: `${inputDirectory}/${videoName}`,
      Body: fs.createReadStream(file.path),
    };
    
    console.log('#################################################');
    console.log('Uploading video to S3...');
    await s3.upload(params, (err: any, data: any) => {
      if (err) {
        return res.status(500).send(err);
      }
    });

    console.log('#################################################');
    console.log('Saving data in DynamoDB...');
    await persist({userId: 99, videoName: file.originalname, timestamp});

    console.log('#################################################');
    console.log('Adding message in SQS...');
    await addToQueue({userId: 99, videoName: file.originalname});

    const msg = `File "${req.file.filename}" was uploaded.`;

    console.log('#################################################');
    console.log('Finished!');
    console.log(msg);

    return res.status(200).json({message: msg});
  } catch (error: any) {
    console.error('Error', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ error: error.message })
    };
  }
});

app.use((err: any, req: any, res: any, next: any) => {
  if (err instanceof multer.MulterError) {
    console.error('Erro Multer:', err); res.status(400).send(`Erro Multer: ${err.message}`);
  } else {
    next(err);
  }
});

async function persist(params: any) {
  try {
    const { userId, videoName, timestamp } = params;
    const nameWithNoExtension = videoName.split('.')[0];
    await save({
      body: {
        object_key: `${userId}_${timestamp}_${nameWithNoExtension}`,
        userId,
        videoName: `${userId}_${timestamp}_${videoName}`,
        timestamp: new Date(timestamp).toISOString(),
        status: 'A_PROCESSAR'
      }
    });
  } catch (error: any) {
    console.error('Error', error);
    return error;
  }
}

async function addToQueue(params: any) {
  const { userId, videoName } = params;
  const timestamp = new Date().getTime();
  const nameWithNoExtension = videoName.split('.')[0];
  await addMessage({
    body: {
      object_key: `${userId}_${timestamp}_${nameWithNoExtension}`,
      userId,
      videoName: `${userId}_${timestamp}_${videoName}`,
    }
  });
}

module.exports.handler = serverless(app);