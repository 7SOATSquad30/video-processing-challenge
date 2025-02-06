import { DynamoDBClientConfig } from "@aws-sdk/client-dynamodb";
import { S3ClientConfig } from "@aws-sdk/client-s3";
import { SQSClientConfig } from "@aws-sdk/client-sqs";

enum Environment { 
    production = 'production', 
    development = 'development' 
};

type DynamoConfig = {
    tableName: string;
    client: DynamoDBClientConfig;
}

type SQSConfig = {
    queueUrl: string;
    client: SQSClientConfig;
}

type S3Config = {
    bucketName: string;
    client: S3ClientConfig;
}

type Configs = {
    dynamo: DynamoConfig,
    sqs: SQSConfig,
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
        dynamo: {
            client: {},
            tableName: process.env.DYNAMODB_TABLE_NAME!,
        },
        sqs: {
            client: {},
            queueUrl: process.env.SQS_QUEUE_URL!,
        },
        s3: {
            client: {},
            bucketName: process.env.INPUT_S3_BUCKET!,
        }
    },
    [Environment.development]: {
        dynamo: {
            client: baseLocalstackConfig,
            tableName: process.env.DYNAMODB_TABLE_NAME!
        },
        sqs: {
            client: baseLocalstackConfig,
            queueUrl: process.env.SQS_QUEUE_URL!,
        },
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