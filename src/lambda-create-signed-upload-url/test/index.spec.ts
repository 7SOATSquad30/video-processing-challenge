import * as index from "../src/index";
import jwt from "jsonwebtoken";

jest.mock("../src/config", () => ({
  getConfigs: jest.fn().mockReturnValue({
    dynamo: {
      client: {
        region: "us-east-1",
      },
    },
  }),
}));

jest.mock("../src/storage.service", () => ({
  generateSignedUrlForFileUpload: jest
    .fn()
    .mockResolvedValue("https://signed-url.com"),
}));

const handler = index.handler;

const encodeJwt = (payload: Record<string, any>) => {
  return jwt.sign(payload, "whatever", { expiresIn: "1h" });
};

describe("Lambda tests", () => {

  /*it("should return 401 if token is invalid", async () => {
    const event = {
      headers: {
        Authorization: "Bearer invalid.token",
      },
      body: JSON.stringify({
        videoFileName: "test.mp4",
        videoMimeType: "video/mp4",
      }),
    };

    const response = await handler(event);
    expect(response.statusCode).toBe(401);
    expect(JSON.parse(response.body).message).toBe("Invalid token");
  });

  it("should return 400 if request body is missing fields", async () => {
    const token = encodeJwt({ email: "test@example.com" });
    const event = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        videoFileName: "test.mp4",
      }),
    };

    const response = await handler(event);
    expect(response.statusCode).toBe(400);
    expect(JSON.parse(response.body).message).toBe(
      "Request body must contain: videoFileName, videoMimeType"
    );
  });

  it("should return 400 if video mime type is not allowed", async () => {
    const token = encodeJwt({ email: "test@example.com" });
    const event = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        videoFileName: "test.mp4",
        videoMimeType: "video/unsupported",
      }),
    };

    const response = await handler(event);
    expect(response.statusCode).toBe(400);
    expect(JSON.parse(response.body).message).toBe(
      "Unsupported video mime type. Allowed types are: video/mp4, video/avi, video/mkv, video/webm"
    );
  });*/

  it("should return 200 and signed URL if request is valid", async () => {
    const token = encodeJwt({ email: "test@example.com" });
    const event = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        videoFileName: "test.mp4",
        videoMimeType: "video/mp4",
      }),
    };

    const response = await handler(event);
    expect(response.statusCode).toBe(200);
    expect(JSON.parse(response.body).uploadUrl).toBe("https://signed-url.com");
  });
});
