import { UploadVideoRequest, Video, VideoProcessingStatus } from "./model";
import { validateVideoWasUploaded } from "./storage.service";
import { saveVideo } from "./video.repository";
import { notifyNewVideoToBeProcessed } from "./messaging.service";

exports.handler = async (event: any) => {
    try {
        console.log('Event:', event);
        
        const userId = event?.pathParameters?.userId || event?.userId;
        if (!userId) {
          return {
            statusCode: 400,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: 'Field usedId is required.' })
          };
        }

        const request: UploadVideoRequest = JSON.parse(event.body);

        const uploadTimestamp = new Date().getTime();
        const video: Video = {
          userId,
          videoId: request.videoFileName,
          status: VideoProcessingStatus.ENQUEUED,
          s3ObjectKey: `${userId}_${request.videoFileName}`,
          timestamp: uploadTimestamp,
        };

        await validateVideoWasUploaded(video.s3ObjectKey);
        await saveVideo(video);
        await notifyNewVideoToBeProcessed(video);

        const message = `Video ${request.videoFileName} upload was completed for user ${userId}.`;
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
