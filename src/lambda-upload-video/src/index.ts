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
  const timestamp = new Date().getTime();
  const userId = req.params.userId;
  const file = req.file;
  const videoName = `${userId}_${timestamp}_${file.originalname}`;
  const params = {
    Bucket: bucket_name,
    Key: `${inputDirectory}/${videoName}`,
    Body: fs.createReadStream(file.path),
  };
  s3.upload(params, (err: any, data: any) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.status(200).send(data);
  });

  await persist({userId: 99, videoName: file.originalname});

  await addToQueue({userId: 99, videoName: file.originalname});

  const msg = req.file ? `File "${req.file.filename}" was uploaded.` : 'No file uploaded.';
  console.log(msg);
  res.status(200).json({message: msg});
});

// app.use('files', express.static('uploads'));

app.use((err: any, req: any, res: any, next: any) => {
  if (err instanceof multer.MulterError) {
    console.error('Erro Multer:', err); res.status(400).send(`Erro Multer: ${err.message}`);
  } else {
    next(err);
  }
});

async function persist(params: any) {
  const { userId, videoName } = params;
  const timestamp = new Date().getTime();
  const nameWithNoExtension = videoName.split('.')[0];
  await save({
    body: {
      id: `${userId}_${timestamp}_${nameWithNoExtension}`,
      userId,
      videoName: `${userId}_${timestamp}_${videoName}`,
      creationDate: new Date(timestamp).toISOString(),
      status: 'A_PROCESSAR'
    }
  });
}

async function addToQueue(params: any) {
  const { userId, videoName } = params;
  const timestamp = new Date().getTime();
  const nameWithNoExtension = videoName.split('.')[0];
  await addMessage({
    body: {
      id: `${userId}_${timestamp}_${nameWithNoExtension}`,
      userId,
      videoName: `${userId}_${timestamp}_${videoName}`,
    }
  });
}

module.exports.handler = serverless(app);