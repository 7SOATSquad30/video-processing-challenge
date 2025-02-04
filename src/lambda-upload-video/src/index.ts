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
          timestamp: new Date().getTime()
        };

        if (!userId) {
          return {
            statusCode: 400,
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ error: 'Field usedId is required.' })
          };
        }

        // TODO recolocar validação após resolver problema API Gateway
        // if (!contentType?.startsWith("multipart/form-data")) {
        //     return {
        //         statusCode: 400,
        //         body: JSON.stringify({ message: "Invalid Content-Type" })
        //     };
        // }

        // const bb = busboy({ headers: event.headers });
        // const fileData: any = [];

        // await new Promise((resolve: any, reject: any) => {
        //     bb.on("file", (fieldname: any, file: any, filename: any, encoding: any, mimetype: any) => {
        //         file.on("data", (data: any) => fileData.push(data));
        //         file.on("end", () => {
        //           params.file = filename;
        //           resolve();
        //       });
        //     });

        //     bb.on("error", (err: any) => reject(err));
        //     bb.end(Buffer.from(event.body, "base64"));
        // });

        // TODO mock
        params.file = 'video.mp4';

        params.key = `${userId}_${params.timestamp}_${params.file.split('.')[0]}`;
        params.videoName = `${userId}_${params.timestamp}_${params.file}`;
        // params.body = Buffer.concat(fileData);
        
        // Cria um arquivo fake
        const fakeFilePath = await createFakeFile(params.videoName);
        params.body = fs.readFileSync(fakeFilePath);
        params.ContentType = 'video/mp4'; // Adiciona Content-Type fake

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
            body: JSON.stringify({message})
        };
    } catch (error: any) {
      console.error('Error', error);
      return {
          statusCode: 500,
          body: JSON.stringify({ message: "Erro ao processar upload do video.", error: error.message })
      };
    }
};

/*
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

    console.log('#################################################');
    console.log('Uploading file to S3 bucket...');
    await uploadToS3({userId, timestamp, file: req.file});

    console.log('#################################################');
    console.log('Saving data in DynamoDB...');
    await persist({userId: 99, videoName: req.file.originalname, timestamp});

    console.log('#################################################');
    console.log('Adding message in SQS...');
    await addToQueue({userId: 99, videoName: req.file.originalname});

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
}); */

async function uploadToS3(params: any) {
  try {
    await s3Upload(params);
    console.log('OK - File uploaded to S3.');
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
    console.log('OK - Data saved in DynamoDB.');
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
    console.log('OK - Message added to SQS.');
  } catch (error: any) {
    console.error('SQS Error', error);
    return error;
  }
}

// Função para criar um arquivo fake
async function createFakeFile(fileName: string): Promise<any> {
    const filePath = path.join('/tmp', fileName);
    await fs.writeFileSync(filePath, 'Conteúdo fake do arquivo de vídeo');
    return filePath;
}

// module.exports.handler = serverless(app);