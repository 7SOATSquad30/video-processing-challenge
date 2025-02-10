import boto3
from moto import mock_aws
import pytest
from unittest.mock import patch
from src.service.s3_upload_file import upload_file_to_s3
import uuid  # Adicionado para gerar nomes únicos


# Configura o mock do S3
s3_client = boto3.client('s3')

# Testes unitários
class TestUploadFileToS3:
    @mock_aws
    def test_upload_file_to_s3_success(self):
        # Configura o mock do S3
        bucket_name = f'test-bucket-{uuid.uuid4().hex}'  # Nome único para o bucket
        object_key = 'test_file.txt'
        file_path = '/tmp/test_file.txt'

        # Cria um arquivo de teste local
        with open(file_path, 'w') as f:
            f.write('test content')

        # Cria um bucket no S3
        s3_client.create_bucket(Bucket=bucket_name)

        # Chama a função para fazer o upload
        upload_file_to_s3(file_path, bucket_name, object_key)

        # Verifica se o arquivo foi enviado corretamente
        response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
        assert response['Body'].read().decode() == 'test content'

    @mock_aws
    @patch('src.config.config.logger.error')
    def test_upload_file_to_s3_file_not_found(self, mock_logger_error):
        # Configura o mock do S3
        bucket_name = f'test-bucket-{uuid.uuid4().hex}'  # Nome único para o bucket
        object_key = 'test_file.txt'
        file_path = '/tmp/non_existent_file.txt'  # Arquivo que não existe

        # Cria um bucket no S3
        s3_client.create_bucket(Bucket=bucket_name)

        # Chama a função e espera uma exceção
        with pytest.raises(Exception):
            upload_file_to_s3(file_path, bucket_name, object_key)

        # Verifica se o erro foi logado corretamente
        mock_logger_error.assert_called()

    @mock_aws
    @patch('src.config.config.logger.error')
    def test_upload_file_to_s3_bucket_not_found(self, mock_logger_error):
        # Configura o mock do S3
        bucket_name = f'non_existent_bucket-{uuid.uuid4().hex}'  # Bucket que não existe
        object_key = 'test_file.txt'
        file_path = '/tmp/test_file.txt'

        # Cria um arquivo de teste local
        with open(file_path, 'w') as f:
            f.write('test content')

        # Chama a função e espera uma exceção
        with pytest.raises(Exception):
            upload_file_to_s3(file_path, bucket_name, object_key)

        # Verifica se o erro foi logado corretamente
        mock_logger_error.assert_called()

# Executa os testes
if __name__ == '__main__':
    pytest.main()