import boto3
from moto import mock_aws
import pytest
from unittest.mock import patch
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../../'))
from app.src.service.s3_download_file import download_file_from_s3


# Testes unitários
class TestDownloadFileFromS3:
    @mock_aws
    def test_download_file_from_s3_success(self):
        # Configura o mock do S3
        s3_client = boto3.client('s3', region_name='us-east-1')
        bucket_name = 'test-bucket'
        video_name = 'test_video.mp4'
        object_key = video_name
        download_path = '/tmp/test_video.mp4'

        # Cria um bucket e adiciona um arquivo de teste
        s3_client.create_bucket(Bucket=bucket_name)
        s3_client.put_object(Bucket=bucket_name, Key=object_key, Body=b'test content')

        # Chama a função para fazer o download
        download_file_from_s3(bucket_name, video_name, download_path)

        # Verifica se o arquivo foi baixado corretamente
        with open(download_path, 'rb') as f:
            assert f.read() == b'test content'

    @mock_aws
    @patch('app.src.config.config.logger.error')
    def test_download_file_from_s3_file_not_found(self, mock_logger_error):
        # Configura o mock do S3
        s3_client = boto3.client('s3', region_name='us-east-1')
        bucket_name = 'test-bucket'
        video_name = 'non_existent_video.mp4'
        download_path = '/tmp/non_existent_video.mp4'

        # Cria um bucket sem adicionar o arquivo
        s3_client.create_bucket(Bucket=bucket_name)

        # Chama a função e espera uma exceção
        with pytest.raises(Exception):
            download_file_from_s3(bucket_name, video_name, download_path)

        # Verifica se o erro foi logado corretamente
        mock_logger_error.assert_called()

    @mock_aws
    @patch('app.src.config.config.logger.error')
    def test_download_file_from_s3_bucket_not_found(self, mock_logger_error):
        # Configura o mock do S3
        bucket_name = 'non_existent_bucket'
        video_name = 'test_video.mp4'
        download_path = '/tmp/test_video.mp4'

        # Chama a função e espera uma exceção
        with pytest.raises(Exception):
            download_file_from_s3(bucket_name, video_name, download_path)

        # Verifica se o erro foi logado corretamente
        mock_logger_error.assert_called()

# Executa os testes
if __name__ == '__main__':
    pytest.main()