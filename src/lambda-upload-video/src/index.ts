import { UploadVideoRequest, UserData, Video, VideoProcessingStatus } from "./model";
import { validateVideoWasUploaded } from "./storage.service";
import { saveVideo } from "./video.repository";
import { notifyNewVideoToBeProcessed } from "./messaging.service";
import jwt from 'jsonwebtoken';

exports.handler = async (event: any) => {
    console.log('Event:', event);

    const token = event.headers.Authorization.split(" ")[1];
    const userData = <UserData | undefined> jwt.decode(token, { complete: true })?.payload;
    if (!userData?.name || !userData?.email) {
      return {
        statusCode: 401,
        body: JSON.stringify({
          message: 'Invalid token',
        }),
      };
    }

    try {
      const request: UploadVideoRequest = JSON.parse(event.body);

      const uploadTimestamp = new Date().getTime();
      const video: Video = {
        userId: userData.email,
        userEmail: userData.email,
        videoId: request.videoFileName,
        status: VideoProcessingStatus.ENQUEUED,
        s3ObjectKey: `${userData.email}_${request.videoFileName}`,
        timestamp: uploadTimestamp,
      };

      await validateVideoWasUploaded(video.s3ObjectKey);
      await saveVideo(video);
      await notifyNewVideoToBeProcessed(video);

      const message = `Video ${request.videoFileName} upload was completed for user ${userData.email}.`;
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
