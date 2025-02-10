import jwt from 'jsonwebtoken';

import * as videosRepository from "../src/videos.repository";
const handler = require("../src/index").handler;

jest.mock('../src/videos.repository');

jest.mock("../src/config", () => ({
    getConfigs: jest.fn().mockReturnValue({
      dynamo: {
        client: {
          region: "us-east-1",
        },
      },
    }),
  }));

jest.mock("@aws-sdk/client-dynamodb", () => ({
    DynamoDBClient: jest.fn(),
}));

jest.mock("@aws-sdk/lib-dynamodb", () => ({
    DynamoDBDocumentClient: {
        from: jest.fn(),
    },
    QueryCommand: jest.fn(),
}));


const encodeJwt = (payload: Record<string, any>) => {
    return jwt.sign(payload, 'whatever', { expiresIn: "1h" });
}

describe("Lambda tests", () => {
    it("should return user videos when user has videos", async () => {
        // given - user has videos
        const userVideos = [{ userId: "123", videoId: "123" }];
        (videosRepository.getUserVideos as jest.Mock).mockResolvedValue(userVideos);

        // when - requesting user videos
        const userToken = encodeJwt({ email: 'fake@fake.com' });
        const response = await handler({
            headers: {
                Authorization: `Bearer ${userToken}`,
            }
        });

        // then - returns user videos
        const body = JSON.parse(response.body);
        expect(response.statusCode).toBe(200);
        expect(body).toEqual({ videos: userVideos });
    });

    it("should return not found when user has no videos", async () => {
        // given - user has no videos
        const userVideos: any[] = [];
        (videosRepository.getUserVideos as jest.Mock).mockResolvedValue(userVideos);

        // when - requesting user videos
        const userToken = encodeJwt({ email: 'fake@fake.com' });
        const response = await handler({
            headers: {
                Authorization: `Bearer ${userToken}`,
            }
        });

        // then - returns not found
        const body = JSON.parse(response.body);
        expect(response.statusCode).toBe(404);
    });

    it("should return unauthorized when auth token is invalid", async () => {
        // given - auth token is invalid
        const userToken = 'abobrinha';
        
        // when - requesting user videos
        const response = await handler({
            headers: {
                Authorization: `Bearer ${userToken}`,
            }
        });

        // then - returns unauthorized
        const body = JSON.parse(response.body);
        expect(response.statusCode).toBe(401);
    });
});