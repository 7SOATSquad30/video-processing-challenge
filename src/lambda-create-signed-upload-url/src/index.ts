import { CreateSignedUploadUrlRequest } from "./model";
import { generateSignedUrlForFileUpload } from "./storage.service";

const ALLOWED_FILE_TYPES = [
  'video/mp4',
  'video/avi',
  'video/mkv',
  'video/webm',
];

exports.handler = async (event: any) => {
  console.log('event:', event);

  const userId = event?.pathParameters?.userId || event?.userId;
  if (!userId) {
    return {
      statusCode: 400,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ error: 'Field usedId is required.' })
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

  const videoS3Key = `${userId}_${request.videoFileName}`;
  const signedUrl = await generateSignedUrlForFileUpload(videoS3Key, request.videoMimeType);

  return {
    statusCode: 200,
    body: JSON.stringify({ uploadUrl: signedUrl }),
  };
};
