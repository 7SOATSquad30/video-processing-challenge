import jwt from "jsonwebtoken";
const handler = require("../src/index").handler;

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

const encodeJwt = (payload: Record<string, any>) => {
  return jwt.sign(payload, "whatever", { expiresIn: "1h" });
};

describe("Lambda tests", () => {

  it('baguncinha', () => {
    const x = 'baguncinha';
  });

});
