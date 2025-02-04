import boto3
from src.config.config import logger
from src.config.config import get_env_variable


def send_email_notification(source_email, to_email, error_message):
    ses_client = boto3.client('ses')
    logger.info(f"E-mail do cliente: {to_email}")
    logger.info(f"Source email: {source_email}")
    response = ses_client.send_email(
        Source=source_email,
        Destination={'ToAddresses': [to_email]},
        Message={
            'Subject': {'Data': 'Processamento Lambda'},
            'Body': {'Text': {'Data': error_message}}
        }
    )
    logger.info(f"E-mail de retorno enviado para {to_email}: {response}")