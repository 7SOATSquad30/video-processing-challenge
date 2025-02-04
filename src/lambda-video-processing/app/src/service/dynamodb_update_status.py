import boto3
from src.config.config import logger

dynamodb = boto3.client('dynamodb')

def update_status_in_dynamodb(table_name, object_key, status):
    """
    Atualiza o status de processamento no DynamoDB.

    :param table_name: Nome da tabela DynamoDB.
    :param object_key: Nome do video.
    :param status: Novo status a ser atualizado.
    """
    try:
        logger.info(f"Atualizando status para '{status}' no DynamoDB para {object_key}")
        logger.info(f"Nome da tabela DynamoDB: {table_name}")
        dynamodb.update_item(
            TableName=table_name,
            Key={'object_key': {'S': object_key}},
            UpdateExpression='SET processing_status = :status',
            ExpressionAttributeValues={':status': {'S': status}}
        )
        logger.info(f"Status atualizado para '{status}' no DynamoDB para {object_key}")
    except Exception as e:
        logger.error(f"Erro ao atualizar status no DynamoDB: {str(e)}")
        raise e