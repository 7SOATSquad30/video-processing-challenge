import json
import os

from app.src.service.s3_download_file import download_file_from_s3
from app.src.service.dynamodb_update_status import update_status_in_dynamodb
from app.src.service.s3_upload_file import upload_file_to_s3
from app.src.service.ffmpeg_extract_frames import extract_frames_with_ffmpeg
from app.src.service.create_zip_from_folder import create_zip_from_folder
from app.src.service.send_email_notification import send_email_notification
from app.src.config.config import logger
from app.src.config.config import get_env_variable

def lambda_handler(event, context):
    """
    Função Lambda para processar eventos do SQS e baixar arquivos do S3.
    
    :param event: Evento recebido do SQS.
    :param context: Contexto da execução Lambda.
    """
    try:
        table_name = get_env_variable('DYNAMODB_TABLE_NAME')
        output_bucket_name = get_env_variable('OUTPUT_S3_BUCKET')
        processed_files = []


        for record in event['Records']:
            message_body = json.loads(record['body'])
            bucket_name = message_body['bucket_name']
            object_key = message_body['object_key']
            client_email = message_body['client_email']
            download_path = os.path.join('/tmp', os.path.basename(object_key))
            output_frames_dir = os.path.join('/tmp', 'frames')
            zip_file_path = os.path.join('/tmp', 'frames.zip')

            # Atualiza status para "Em processamento"
            update_status_in_dynamodb(table_name, object_key, 'Em processamento')

            logger.info(f"Iniciando download do arquivo: {object_key} do bucket: {bucket_name}")
            download_file_from_s3(bucket_name, object_key, download_path)

            # Extrai frames do vídeo usando FFmpeg
            extract_frames_with_ffmpeg(download_path, output_frames_dir)

            # Compacta os frames em um arquivo .zip
            create_zip_from_folder(output_frames_dir, zip_file_path)

            # Faz upload do arquivo zip para o bucket S3 de saída
            upload_key = f"processed/{os.path.basename(zip_file_path)}"
            upload_file_to_s3(zip_file_path, output_bucket_name, upload_key)
            logger.info(f"Arquivo ZIP carregado com sucesso para: {output_bucket_name}/{upload_key}")

            # Atualiza status para "Processado"
            update_status_in_dynamodb(table_name, object_key, 'Processado')
            processed_files.append(upload_key)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Processamento concluido', 'files': processed_files})
        }
    
    except KeyError as e:
        error_message = f"Erro: Chave ausente no evento - {str(e)}"
        logger.error(error_message)
        send_email_notification(client_email, error_message)
    except json.JSONDecodeError as e:
        error_message = f"Erro ao decodificar JSON - {str(e)}"
        logger.error(error_message)
        send_email_notification(client_email, error_message)
    except Exception as e:
        error_message = f"Erro inesperado: {str(e)}"
        logger.error(error_message)
        send_email_notification(client_email, error_message)

    return {
        'statusCode': 500,
        'body': json.dumps('Erro interno no processamento')
    }