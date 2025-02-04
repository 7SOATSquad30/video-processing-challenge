# import json
# from unittest.mock import patch
# import pytest
# from moto import mock_aws
# from lambda_function import lambda_handler

# # Testes unitários
# class TestLambdaHandler:
#     @mock_aws
#     @mock_aws
#     @mock_aws
#     @patch('src.service.s3_download_file.download_file_from_s3')
#     @patch('src.service.dynamodb_update_status.update_status_in_dynamodb')
#     @patch('src.service.s3_upload_file.upload_file_to_s3')
#     @patch('src.service.ffmpeg_extract_frames.extract_frames_with_ffmpeg')
#     @patch('src.service.create_zip_from_folder.create_zip_from_folder')
#     @patch('src.service.send_email_notification.send_email_notification')
#     @patch('src.config.config.get_env_variable')
#     def test_lambda_handler_success(
#         self,
#         mock_get_env_variable,
#         mock_send_email_notification,
#         mock_create_zip_from_folder,
#         mock_extract_frames_with_ffmpeg,
#         mock_upload_file_to_s3,
#         mock_update_status_in_dynamodb,
#         mock_download_file_from_s3,
#     ):
#         # Configura os mocks
#         mock_get_env_variable.side_effect = lambda x: {
#             'DYNAMODB_TABLE_NAME': 'test-table',
#             'S3_BUCKET': 'test-bucket',
#         }[x]

#         # Configura o evento de teste
#         event = {
#             'Records': [
#                 {
#                     'body': json.dumps({
#                         'videoName': 'test_video.mp4',
#                         'client_email': 'client@example.com',
#                     })
#                 }
#             ]
#         }

#         # Chama a função Lambda
#         response = lambda_handler(event, {})

#         # Verifica se a resposta está correta
#         assert response['statusCode'] == 200
#         assert 'Processamento concluido' in response['body']

#         # Verifica se as funções foram chamadas corretamente
#         mock_update_status_in_dynamodb.assert_any_call('test-table', 'test_video.mp4', 'PROCESSANDO')
#         mock_download_file_from_s3.assert_called_once_with('test-bucket', 'test_video.mp4', '/tmp/test_video.mp4')
#         mock_extract_frames_with_ffmpeg.assert_called_once_with('/tmp/test_video.mp4', '/tmp/frames')
#         mock_create_zip_from_folder.assert_called_once_with('/tmp/frames', '/tmp/test_video.mp4.zip')
#         mock_upload_file_to_s3.assert_called_once_with('/tmp/test_video.mp4.zip', 'test-bucket', 'output/test_video.mp4.zip')
#         mock_update_status_in_dynamodb.assert_any_call('test-table', 'test_video.mp4', 'SUCESSO')
#         mock_send_email_notification.assert_called_once_with('client@example.com', 'Processamento concluido: [\'output/test_video.mp4.zip\']')

#     @mock_aws
#     @patch('src.service.s3_download_file.download_file_from_s3')
#     @patch('src.service.dynamodb_update_status.update_status_in_dynamodb')
#     @patch('src.service.send_email_notification.send_email_notification')
#     @patch('src.config.config.get_env_variable')
#     def test_lambda_handler_failure(
#         self,
#         mock_get_env_variable,
#         mock_send_email_notification,
#         mock_update_status_in_dynamodb,
#         mock_download_file_from_s3,
#     ):
#         # Configura os mocks
#         mock_get_env_variable.side_effect = lambda x: {
#             'DYNAMODB_TABLE_NAME': 'test-table',
#             'S3_BUCKET': 'test-bucket',
#         }[x]

#         # Simula uma exceção no download do arquivo
#         mock_download_file_from_s3.side_effect = Exception("Erro ao baixar arquivo")

#         # Configura o evento de teste
#         event = {
#             'Records': [
#                 {
#                     'body': json.dumps({
#                         'videoName': 'test_video.mp4',
#                         'client_email': 'client@example.com',
#                     })
#                 }
#             ]
#         }

#         # Chama a função Lambda
#         response = lambda_handler(event, {})

#         # Verifica se a resposta está correta
#         assert response['statusCode'] == 500
#         assert 'Erro interno no processamento' in response['body']

#         # Verifica se as funções foram chamadas corretamente
#         mock_update_status_in_dynamodb.assert_any_call('test-table', 'test_video.mp4', 'PROCESSANDO')
#         mock_update_status_in_dynamodb.assert_any_call('test-table', 'test_video.mp4', 'ERRO')
#         mock_send_email_notification.assert_called_once_with('client@example.com', 'Erro inesperado: Erro ao baixar arquivo')

# # Executa os testes
# if __name__ == '__main__':
#     pytest.main()