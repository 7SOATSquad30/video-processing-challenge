export enum VideoProcessingStatus {
    ENQUEUED = 'ENQUEUED',
    PROCESSING = 'PROCESSING',
    COMPLETED = 'COMPLETED',
    FAILED = 'FAILED',
}

export interface Video {
    userId: string;
    userEmail: string;
    videoId: string;
    status: VideoProcessingStatus;
    s3ObjectKey: string;
    timestamp: number;
}

export type UploadVideoRequest = {
    videoFileName: string,
}

export interface UserData {
    name: string,
    email: string,
}