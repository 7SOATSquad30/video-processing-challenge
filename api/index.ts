import express from 'express';
import multer from 'multer';
import { storage } from './multerConfig';

const upload = multer({ storage: storage });

const app = express();

app.post('/upload', upload.single('file'), (req, res) => {
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