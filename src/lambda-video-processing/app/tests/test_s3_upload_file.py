import zipfile
import boto3
import unittest
from moto import mock_s3
from io import BytesIO

class TestS3UploadFile(unittest.TestCase):

    @mock_s3
    def test_upload_zip_to_s3(self):
        # Set up mock S3
        s3 = boto3.client('s3', region_name='us-east-1')
        bucket_name = 'test-bucket'
        s3.create_bucket(Bucket=bucket_name)

        # Create a zip file in memory
        zip_buffer = BytesIO()
        with zipfile.ZipFile(zip_buffer, 'w') as zip_file:
            zip_file.writestr('test.txt', 'This is a test file.')

        zip_buffer.seek(0)

        # Upload the zip file to S3
        s3.upload_fileobj(zip_buffer, bucket_name, 'test.zip')

        # Verify the file was uploaded
        response = s3.list_objects_v2(Bucket=bucket_name)
        self.assertEqual(len(response['Contents']), 1)
        self.assertEqual(response['Contents'][0]['Key'], 'test.zip')

if __name__ == '__main__':
    unittest.main()