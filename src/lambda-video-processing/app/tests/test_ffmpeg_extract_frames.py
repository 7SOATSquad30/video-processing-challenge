from moto import mock_aws
import pytest
from unittest.mock import patch, MagicMock
import os
from src.service.ffmpeg_extract_frames import extract_frames_with_ffmpeg, FFMPEG_BIN_PATH


# Testes unitários
class TestExtractFramesWithFFmpeg:
    @mock_aws  # Usando mock_aws para simular serviços da AWS
    @patch('os.path.isfile')  # Mock para simular a existência do FFmpeg
    @patch('subprocess.run')  # Mock do subprocess.run para simular o FFmpeg
    def test_extract_frames_with_ffmpeg_success(self, mock_subprocess_run, mock_isfile):
        # Configuração do teste
        video_path = '/tmp/test_video.mp4'
        output_dir = '/tmp/frames'

        # Cria um arquivo de vídeo de teste
        with open(video_path, 'wb') as f:
            f.write(b'test video content')

        # Configura o mock para simular que o FFmpeg existe
        mock_isfile.return_value = True

        # Configura o mock do subprocess.run para simular o FFmpeg
        mock_subprocess_run.return_value = MagicMock(returncode=0)

        # Chama a função
        result = extract_frames_with_ffmpeg(video_path, output_dir)

        # Verifica se a função retornou o diretório correto
        assert result == output_dir

        # Verifica se o subprocess.run foi chamado corretamente
        mock_subprocess_run.assert_called_once()

    @mock_aws  # Usando mock_aws para simular serviços da AWS
    @patch('os.path.isfile')  # Mock para simular a existência do FFmpeg
    @patch('src.config.config.logger.error')
    def test_extract_frames_with_ffmpeg_failure(self, mock_logger_error, mock_isfile):
        # Configuração do teste
        video_path = '/tmp/non_existent_video.mp4'
        output_dir = '/tmp/frames'

        # Configura o mock para simular que o FFmpeg não existe
        mock_isfile.return_value = False

        # Chama a função e espera uma exceção
        with pytest.raises(FileNotFoundError):
            extract_frames_with_ffmpeg(video_path, output_dir)

        # Verifica se o erro foi logado corretamente
        mock_logger_error.assert_called()


# Executa os testes
if __name__ == '__main__':
    pytest.main()