import { DynamoDBClientConfig } from "@aws-sdk/client-dynamodb";

enum Environment { 
    production = 'production', 
    development = 'development' 
};

type DynamoConfig = {
    tableName: string;
    client: DynamoDBClientConfig;
}

type Configs = {
    dynamo: DynamoConfig,
}

type EnvironmentConfigs = {
    [K in Environment]: Configs;
}

const baseLocalstackConfig: DynamoDBClientConfig = {
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
        }
    },
    [Environment.development]: {
        dynamo: {
            client: baseLocalstackConfig,
            tableName: process.env.DYNAMODB_TABLE_NAME!
        }
    },
}

export const getConfigs = () => configs[process.env.ENVIRONMENT as Environment];