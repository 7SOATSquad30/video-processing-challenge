import awsServerlessExpress from 'aws-serverless-express';
import app from './index';
import { APIGatewayEvent, Context } from 'aws-lambda';

const server = awsServerlessExpress.createServer(app);
exports.handler = (event: APIGatewayEvent, context: Context) => {
// exports.handler = (event: AWSLambda.APIGatewayEvent, context: AWSLambda.Context) => {
    awsServerlessExpress.proxy(server, event, context);
};
