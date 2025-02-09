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
            KeySchema=[{'AttributeName': 'object_key', 'KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'object_key', 'AttributeType': 'S'}],
            ProvisionedThroughput={'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}
        )

        # Insere um item de teste na tabela
        self.object_key = 'test_video.mp4'
        self.dynamodb.put_item(
            TableName=self.table_name,
            Item={'object_key': {'S': self.object_key}, 'processing_status': {'S': 'pending'}}
        )


    @mock_aws  # Usando mock_aws para simular o DynamoDB
    @patch('src.config.config.logger.error')  # Mock do logger para capturar erros
    def test_update_status_in_dynamodb_failure(self, mock_logger_error):
        # Tenta atualizar o status em uma tabela que não existe
        with self.assertRaises(Exception):
            update_status_in_dynamodb('non_existent_table', self.object_key, 'processed')


# Executa os testes
if __name__ == '__main__':
    unittest.main()