import boto3
import unittest
from unittest.mock import patch
from src.service.dynamodb_update_status import update_status_in_dynamodb
from moto import mock_aws  # Importação correta do mock


# Teste unitário
class TestUpdateStatusInDynamoDB(unittest.TestCase):
    @mock_aws  # Usando mock_aws para simular o DynamoDB
    def setUp(self):
        # Configura o mock do DynamoDB
        self.dynamodb = boto3.client('dynamodb', region_name='us-east-1')
        
        # Cria uma tabela de teste no DynamoDB
        self.table_name = 'test_table'
        self.dynamodb.create_table(
            TableName=self.table_name,
            KeySchema=[
                {'AttributeName': 'user_id', 'KeyType': 'HASH'},  # Chave primária
                {'AttributeName': 'video_id', 'KeyType': 'RANGE'}  # Chave de ordenação
            ],
            AttributeDefinitions=[
                {'AttributeName': 'user_id', 'AttributeType': 'S'},
                {'AttributeName': 'video_id', 'AttributeType': 'S'}
            ],
            ProvisionedThroughput={'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}
        )

        # Insere um item de teste na tabela
        self.user_id = 'user_123'
        self.video_id = 'video_456'
        self.dynamodb.put_item(
            TableName=self.table_name,
            Item={
                'user_id': {'S': self.user_id},
                'video_id': {'S': self.video_id},
                'process_status': {'S': 'pending'}
            }
        )

    @mock_aws
    @patch('src.config.config.logger.info')  # Mock do logger para capturar logs de info
    def test_update_status_in_dynamodb_success(self, mock_logger_info):
        # Novo status a ser atualizado
        new_status = 'processed'

        # Chama a função para atualizar o status
        update_status_in_dynamodb(self.table_name, self.user_id, self.video_id, new_status)

        # Verifica se o status foi atualizado corretamente no DynamoDB
        response = self.dynamodb.get_item(
            TableName=self.table_name,
            Key={
                'user_id': {'S': self.user_id},
                'video_id': {'S': self.video_id}
            }
        )
        self.assertEqual(response['Item']['process_status']['S'], new_status)

        # Verifica se as mensagens de log foram registradas corretamente
        mock_logger_info.assert_any_call(f"Atualizando status para '{new_status}' no DynamoDB para {self.user_id}/{self.video_id}")
        mock_logger_info.assert_any_call(f"Nome da tabela DynamoDB: {self.table_name}")
        mock_logger_info.assert_any_call(f"Status atualizado para '{new_status}' no DynamoDB para {self.user_id}/{self.video_id}")

    @mock_aws
    @patch('src.config.config.logger.error')  # Mock do logger para capturar logs de erro
    def test_update_status_in_dynamodb_failure(self, mock_logger_error):
        # Tenta atualizar o status em uma tabela que não existe
        non_existent_table = 'non_existent_table'
        with self.assertRaises(Exception):
            update_status_in_dynamodb(non_existent_table, self.user_id, self.video_id, 'processed')

        # Verifica se a mensagem de erro foi registrada corretamente
        mock_logger_error.assert_called()

    @mock_aws
    @patch('src.config.config.logger.error')  # Mock do logger para capturar logs de erro
    def test_update_status_in_dynamodb_invalid_key(self, mock_logger_error):
        # Tenta atualizar o status com uma chave inválida
        invalid_user_id = 'invalid_user'
        invalid_video_id = 'invalid_video'
        with self.assertRaises(Exception):
            update_status_in_dynamodb(self.table_name, invalid_user_id, invalid_video_id, 'processed')

        # Verifica se a mensagem de erro foi registrada corretamente
        mock_logger_error.assert_called()


# Executa os testes
if __name__ == '__main__':
    unittest.main()