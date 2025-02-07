import boto3
from src.config.config import logger

dynamodb = boto3.client('dynamodb')

def update_status_in_dynamodb(table_name, user_id, video_id, status):
    """
    Atualiza o status de processamento no DynamoDB.

    :param table_name: Nome da tabela DynamoDB.
    :param user_id: Id do usuário.
    :param video_id: Video do usuário.
    :param status: Novo status a ser atualizado.
    """
    try:
        logger.info(f"Atualizando status para '{status}' no DynamoDB para {user_id}/{video_id}")
        logger.info(f"Nome da tabela DynamoDB: {table_name}")
        dynamodb.update_item(
            TableName=table_name,
            Key={
                'user_id': {'S': user_id},
                'video_id': {'S': video_id}
            },
            UpdateExpression='SET process_status = :status',
            ExpressionAttributeValues={':status': {'S': status}}
        )
        logger.info(f"Status atualizado para '{status}' no DynamoDB para {user_id}/{video_id}")
    except Exception as e:
        logger.error(f"Erro ao atualizar status no DynamoDB: {str(e)}")
        raise e