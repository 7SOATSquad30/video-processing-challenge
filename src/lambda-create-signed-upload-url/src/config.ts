import { S3ClientConfig } from "@aws-sdk/client-s3";

enum Environment { 
    production = 'production', 
    development = 'development' 
};

type S3Config = {
    bucketName: string;
    client: S3ClientConfig;
}

type Configs = {
    s3: S3Config,
}

type EnvironmentConfigs = {
    [K in Environment]: Configs;
}

const baseLocalstackConfig = {
    region: "us-east-1",
    endpoint: "http://localstack:4566",
    credentials: {
        accessKeyId: "test",
        secretAccessKey: "test",
    }
}

const configs: EnvironmentConfigs = {
    [Environment.production]: {
        s3: {
            client: {},
            bucketName: process.env.INPUT_S3_BUCKET!,
        }
    },
    [Environment.development]: {
        s3: {
            client: {
                ...baseLocalstackConfig,
                forcePathStyle: true,
            },
            bucketName: process.env.INPUT_S3_BUCKET!,
        }
    },
}

export const getConfigs = () => configs[process.env.ENVIRONMENT as Environment];