import json
import os

from src.service.s3_download_file import download_file_from_s3
from src.service.dynamodb_update_status import update_status_in_dynamodb
from src.service.s3_upload_file import upload_file_to_s3
from src.service.ffmpeg_extract_frames import extract_frames_with_ffmpeg
from src.service.create_zip_from_folder import create_zip_from_folder
from src.service.send_email_notification import send_email_notification
from src.service.s3_generate_presigned_url import generate_presigned_url
from src.config.config import logger
from src.config.config import get_env_variable

def lambda_handler(event, context):
    """
    Função Lambda para processar eventos do SQS e baixar arquivos do S3.
    
    :param event: Evento recebido do SQS.
    :param context: Contexto da execução Lambda.
    """
    try:
        table_name = get_env_variable('DYNAMODB_TABLE_NAME')
        bucket_name  = get_env_variable('S3_BUCKET')
        source_email = get_env_variable('SES_SOURCE_EMAIL')

        for record in event['Records']:
            message_body = json.loads(record['body'])
            print(message_body)
            user_id = message_body['userId']
            video_id = message_body['videoId']
            video_path = message_body['s3ObjectKey']
            client_email = message_body['userEmail']
            # client_email = 'otavio.sto@gmail.com'
            download_path = os.path.join('/tmp', os.path.basename(video_path))
            output_frames_dir = os.path.join('/tmp', 'frames')
            zip_file_path = os.path.join('/tmp', f'{video_path}.zip')

            # Atualiza status para "PROCESSANDO"
            update_status_in_dynamodb(table_name, user_id, video_id, 'PROCESSANDO')

            logger.info(f"Iniciando download do arquivo: {video_path} do bucket: {bucket_name}")
            download_file_from_s3(bucket_name, video_path, download_path)

            # Extrai frames do vídeo usando FFmpeg
            extract_frames_with_ffmpeg(download_path, output_frames_dir)

            # Compacta os frames em um arquivo .zip
            create_zip_from_folder(output_frames_dir, zip_file_path)

            # Faz upload do arquivo zip para o bucket S3 de saída
            upload_key = f"output/{os.path.basename(zip_file_path)}"
            upload_file_to_s3(zip_file_path, bucket_name, upload_key)
            logger.info(f"Arquivo ZIP carregado com sucesso para: {bucket_name}/{upload_key}")

            # Gera uma url pré-assinada para download do arquivo ZIP
            download_url = generate_presigned_url(bucket_name, upload_key)
            success_message = f"O processamento do vídeo {video_id} foi concluído com sucesso. " \
                                f"Baixe o arquivo ZIP com os frames processados: {download_url}"

            # Envia e-mail de notificação para o cliente
            send_email_notification(source_email, client_email, success_message)

            # Atualiza status para "SUCESSO"
            update_status_in_dynamodb(table_name, user_id, video_id, 'SUCESSO')

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Processamento concluido'})
        }
    
    except KeyError as e:
        error_message = f"Erro: Chave ausente no evento - {str(e)}"
        update_status_in_dynamodb(table_name, user_id, video_id, 'ERRO')
        logger.error(error_message)
        send_email_notification(source_email, client_email, error_message)
    except json.JSONDecodeError as e:
        error_message = f"Erro ao decodificar JSON - {str(e)}"
        update_status_in_dynamodb(table_name, user_id, video_id, 'ERRO')
        logger.error(error_message)
        send_email_notification(source_email, client_email, error_message)
    except Exception as e:
        error_message = f"Erro inesperado: {str(e)}"
        update_status_in_dynamodb(table_name, user_id, video_id, 'ERRO')
        logger.error(error_message)
        send_email_notification(source_email, client_email, error_message)

    return {
        'statusCode': 500,
        'body': json.dumps(error_message)
    }