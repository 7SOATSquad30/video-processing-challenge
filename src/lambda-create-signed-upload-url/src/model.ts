export type CreateSignedUploadUrlRequest = {
    videoFileName: string,
    videoMimeType: string,
}

export interface UserData {
    name: string,
    email: string,
}