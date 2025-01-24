import express from 'express';
import multer from 'multer';
import { storage } from './multerConfig';
import fs from 'fs';
const AWS = require('aws-sdk');

const upload = multer({ storage });

const app = express();

const s3 = new AWS.S3();

app.post('/upload', upload.single('file'), (req: any, res: any) => {
  const file = req.file;
  const params = {
    Bucket: "your-bucket-name",
    Key: file.originalname,
    Body: fs.createReadStream(file.path),
  };
  s3.upload(params, (err: any, data: any) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.status(200).send(data);
  });
  const msg = req.file ? `File "${req.file.filename}" uploaded.` : 'No file uploaded.';
  console.log(msg);
  res.send(msg);
});

app.use('files', express.static('uploads'));

app.use((err: any, req: any, res: any, next: any) => {
  if (err instanceof multer.MulterError) {
    console.error('Erro Multer:', err); res.status(400).send(`Erro Multer: ${err.message}`);
  } else {
    next(err);
  }
});

app.listen(3000, () => {
  console.log('Server started on http://localhost:3000');
});

export default app;