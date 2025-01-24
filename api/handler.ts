import AWS from 'aws-sdk';
const S3 = new AWS.S3();

const config = {
    region: 'us-east-1',
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    bucketName: 'fiap-postech-video-processing',
    bucketKey: 'uploads',
};

export const uploadFile = async (file: any) => {
    const fileData = {
        name: `${new Date().getTime()}_${file.originalname}`,
    }
    try {
        const params = {
            Bucket: config.bucketName,
            Key: `${config.bucketKey}/${fileData.name}`,
            Body: file.buffer,
        };
        await S3.upload(params).promise();
        return `{"message": "File uploaded successfully: ${file.originalname}"}`;
    } catch (error) {
        console.error('Error uploading file:', error);
        throw error;
    }
}
