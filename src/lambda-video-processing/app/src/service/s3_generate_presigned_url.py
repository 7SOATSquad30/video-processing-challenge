import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

def generate_presigned_url(bucket_name, object_name, expiration=3600):
    """
    Gera uma URL pré-assinada para um objeto no Amazon S3.

    :param bucket_name: Nome do bucket S3.
    :param object_name: Nome do objeto no bucket.
    :param expiration: Tempo de expiração da URL em segundos (padrão é 1 hora).
    :return: URL pré-assinada ou None em caso de erro.
    """
    # Cria uma sessão do boto3 e um cliente S3
    s3_client = boto3.client('s3')

    try:
        # Gera a URL pré-assinada
        url = s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket_name, 'Key': object_name},
            ExpiresIn=expiration
        )
        return url
    except (NoCredentialsError, PartialCredentialsError):
        print("Credenciais não encontradas ou incompletas.")
        return None
    except Exception as e:
        print(f"Erro ao gerar URL pré-assinada: {e}")
        return None