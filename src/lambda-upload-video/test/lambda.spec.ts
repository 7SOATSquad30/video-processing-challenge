import { handler } from "../src/index";
import * as storageService from "../src/storage.service";
import * as videoRepository from "../src/video.repository";
import * as messagingService from "../src/messaging.service";
import jwt from "jsonwebtoken";
import { jest } from "@jest/globals";

jest.mock("../src/storage.service", () => ({
  generateSignedUrlForFileUpload: jest.fn(),
  validateVideoWasUploaded: jest.fn(),
}));
jest.mock("../src/video.repository", () => ({
  saveVideo: jest.fn(),
}));
jest.mock("../src/messaging.service", () => ({
  notifyNewVideoToBeProcessed: jest.fn(),
}));
jest.mock('jsonwebtoken');

describe("Lambda tests", () => {
  const mockEvent = {
    headers: {
      Authorization: "Bearer mockToken",
    },
    body: JSON.stringify({
      videoFileName: "test-video.mp4",
    }),
  };

  const mockUserData = {
    email: "test@example.com",
  };

  beforeEach(() => {
    jest.spyOn(jwt, "decode").mockReturnValue({ payload: mockUserData });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should return 401 if token is invalid", async () => {
    jest.spyOn(jwt, "decode").mockReturnValue({ payload: undefined });

    const response = await handler(mockEvent);

    expect(response.statusCode).toBe(401);
    expect(JSON.parse(response.body).message).toBe("Invalid token");
  });

  it("should return 200 if video upload is successful", async () => {
    jest
      .spyOn(storageService, "validateVideoWasUploaded")
      .mockResolvedValue(true);
    jest.spyOn(videoRepository, "saveVideo").mockResolvedValue(undefined);
    jest
      .spyOn(messagingService, "notifyNewVideoToBeProcessed")
      .mockResolvedValue({
        MessageId: "mock-message-id",
        $metadata: {},
      });

    const response = await handler(mockEvent);

    expect(response.statusCode).toBe(200);
    expect(JSON.parse(response.body).message).toBe(
      "Video test-video.mp4 upload was completed for user test@example.com."
    );
    expect(storageService.validateVideoWasUploaded).toHaveBeenCalledWith(
      "test@example.com_test-video.mp4"
    );
    expect(videoRepository.saveVideo).toHaveBeenCalled();
    expect(messagingService.notifyNewVideoToBeProcessed).toHaveBeenCalled();
  });

  it("should return 500 if there is an error during video upload", async () => {
    jest
      .spyOn(storageService, "validateVideoWasUploaded")
      .mockRejectedValue(new Error("Upload error"));

    const response = await handler(mockEvent);

    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body).message).toBe(
      "Erro ao processar upload do video."
    );
    expect(JSON.parse(response.body).error).toBe("Upload error");
  });
});
