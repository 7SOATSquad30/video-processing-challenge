import { CreateSignedUploadUrlRequest, UserData } from "./model";
import { generateSignedUrlForFileUpload } from "./storage.service";
import jwt from 'jsonwebtoken';

const ALLOWED_FILE_TYPES = [
  'video/mp4',
  'video/avi',
  'video/mkv',
  'video/webm',
];

export const handler = async (event: any) => {
  console.log('event:', event);

  const token = event.headers.Authorization.split(" ")[1];
  const userData = <UserData | undefined> jwt.decode(token, { complete: true })?.payload;
  console.log('user', userData);
  if (!userData?.email) {
    return {
      statusCode: 401,
      body: JSON.stringify({
        message: 'Invalid token',
      }),
    };
  }

  const request: CreateSignedUploadUrlRequest = JSON.parse(event.body);

  if (!request.videoFileName || !request.videoMimeType) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Request body must contain: videoFileName, videoMimeType',
      }),
    };
  }

  if (!ALLOWED_FILE_TYPES.includes(request.videoMimeType)) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Unsupported video mime type. Allowed types are: ' + ALLOWED_FILE_TYPES.join(', '),
      }),
    };
  }

  const videoS3Key = `${userData.email}_${request.videoFileName}`;
  const signedUrl = await generateSignedUrlForFileUpload(videoS3Key, request.videoMimeType);

  return {
    statusCode: 200,
    body: JSON.stringify({ uploadUrl: signedUrl }),
  };
};
