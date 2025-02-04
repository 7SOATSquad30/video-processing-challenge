import boto3
from src.config.config import logger

s3_client = boto3.client('s3')


def upload_file_to_s3(file_path, bucket_name, object_key):
    """
    Faz o upload de um arquivo para um bucket S3.

    :param file_path: Caminho local do arquivo a ser enviado.
    :param bucket_name: Nome do bucket S3 de destino.
    :param object_key: Caminho do objeto no S3.
    """
    try:
        logger.info(f"Iniciando upload do arquivo {file_path} para o bucket {bucket_name} com a chave {object_key}")
        s3_client.upload_file(file_path, bucket_name, object_key)
        logger.info("Upload concluído com sucesso!")
    except Exception as e:
        logger.error(f"Erro ao fazer upload para o S3: {str(e)}")
        raise e
