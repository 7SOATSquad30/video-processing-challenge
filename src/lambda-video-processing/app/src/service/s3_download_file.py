import boto3
from src.config.config import logger

def download_file_from_s3(bucket_name: str, video_name: str, download_path: str):
    """
    Faz o download de um arquivo de um bucket S3.

    :param bucket_name: Nome do bucket S3.
    :param object_key: Caminho do arquivo dentro do bucket.
    :param download_path: Caminho local onde o arquivo será salvo.
    """
    try:
        video_name = f"input/{video_name}"
        s3_client = boto3.client('s3')
        logger.info(f"Conectado ao bucket '{bucket_name}'")
        logger.info(f"Tentando baixar o arquivo '{video_name}'...")
        logger.info(f"Salvando o arquivo em '{download_path}'...")

        s3_client.download_file(bucket_name, video_name, download_path)
        logger.info(f"Arquivo '{video_name}' baixado com sucesso para '{download_path}'")
    
    except Exception as e:
        logger.error(f"Erro ao baixar o arquivo: {str(e)}")
        raise e