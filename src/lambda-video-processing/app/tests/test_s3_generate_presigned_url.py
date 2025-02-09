import unittest
from unittest.mock import patch
from moto import mock_aws
import boto3
from src.service.s3_generate_presigned_url import generate_presigned_url


class TestGeneratePresignedUrl(unittest.TestCase):

    @mock_aws
    def test_generate_presigned_url(self):
        # Configuração do ambiente de teste
        bucket_name = 'test-bucket'
        object_name = 'test-file.txt'
        expiration = 3600

        # Cria um cliente S3 mockado
        s3_client = boto3.client('s3', region_name='us-east-1')
        s3_client.create_bucket(Bucket=bucket_name)
        s3_client.put_object(Bucket=bucket_name, Key=object_name, Body='test content')

        # Gera a URL pré-assinada
        presigned_url = generate_presigned_url(bucket_name, object_name, expiration)

        # Verifica se a URL foi gerada corretamente
        self.assertIsNotNone(presigned_url)
        self.assertIn(bucket_name, presigned_url)
        self.assertIn(object_name, presigned_url)

    @patch('boto3.client')
    def test_generate_presigned_url_with_invalid_credentials(self, mock_boto3_client):
        # Configuração do ambiente de teste
        bucket_name = 'test-bucket'
        object_name = 'test-file.txt'
        expiration = 3600

        # Simula uma exceção de credenciais inválidas
        mock_boto3_client.return_value.generate_presigned_url.side_effect = Exception("Credenciais inválidas")

        # Tenta gerar a URL pré-assinada
        presigned_url = generate_presigned_url(bucket_name, object_name, expiration)

        # Verifica se a função retornou None devido à falta de credenciais
        self.assertIsNone(presigned_url)

if __name__ == '__main__':
    unittest.main()