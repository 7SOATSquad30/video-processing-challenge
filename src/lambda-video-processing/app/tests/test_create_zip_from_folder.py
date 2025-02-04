import os
import zipfile
import unittest
import tempfile
import shutil

# Importando a função que será testada
from src.service.create_zip_from_folder import create_zip_from_folder

class TestCreateZipFromFolder(unittest.TestCase):

    def setUp(self):
        # Cria uma pasta temporária para o teste
        self.test_folder = tempfile.mkdtemp()
        
        # Cria alguns arquivos de teste dentro da pasta temporária
        self.file1_path = os.path.join(self.test_folder, 'file1.txt')
        self.file2_path = os.path.join(self.test_folder, 'file2.txt')
        
        # Escreve conteúdo nos arquivos
        with open(self.file1_path, 'w', encoding='utf-8') as f:
            f.write('Conteúdo do arquivo 1')
        
        with open(self.file2_path, 'w', encoding='utf-8') as f:
            f.write('Conteúdo do arquivo 2')
        
        # Define o caminho do arquivo ZIP que será criado
        self.zip_path = os.path.join(self.test_folder, 'test.zip')

    def tearDown(self):
        # Remove a pasta temporária e seu conteúdo após o teste
        shutil.rmtree(self.test_folder)

    def test_create_zip_from_folder(self):
        # Chama a função para criar o ZIP
        create_zip_from_folder(self.test_folder, self.zip_path)
        
        # Verifica se o arquivo ZIP foi criado
        self.assertTrue(os.path.exists(self.zip_path))
        
        # Verifica se os arquivos estão dentro do ZIP
        with zipfile.ZipFile(self.zip_path, 'r') as zipf:
            zip_files = zipf.namelist()
            self.assertIn('file1.txt', zip_files)
            self.assertIn('file2.txt', zip_files)
            
            # Verifica o conteúdo dos arquivos dentro do ZIP
            with zipf.open('file1.txt') as f:
                content = f.read().decode('utf-8')  # Decodifica como UTF-8
                self.assertEqual(content, 'Conteúdo do arquivo 1')
            
            with zipf.open('file2.txt') as f:
                content = f.read().decode('utf-8')  # Decodifica como UTF-8
                self.assertEqual(content, 'Conteúdo do arquivo 2')

if __name__ == '__main__':
    unittest.main()