export enum VideoProcessingStatus {
    ENQUEUED = 'ENQUEUED',
    PROCESSING = 'PROCESSING',
    COMPLETED = 'COMPLETED',
    FAILED = 'FAILED',
}

export interface Video {
    userId: string;
    videoId: string;
    status: VideoProcessingStatus;
    s3ObjectKey: string;
    timestamp: number;
}