import pytest
from unittest.mock import patch, MagicMock
from botocore.exceptions import NoCredentialsError
from src.service.send_email_notification import send_email_notification

@pytest.fixture
def ses_client_mock():
    with patch('boto3.client') as mock_client:
        mock_ses = MagicMock()
        mock_client.return_value = mock_ses
        yield mock_ses

@patch('src.config.config.logger')
def test_send_email_notification_success(mock_logger, ses_client_mock):
    # Arrange
    source_email = 'test-source@example.com'
    to_email = 'recipient@example.com'
    error_message = 'Sample error message'
    ses_client_mock.send_email.return_value = {'MessageId': '12345'}

    # Act
    send_email_notification(source_email, to_email, error_message)

    # Assert
    ses_client_mock.send_email.assert_called_once_with(
        Source=source_email,
        Destination={'ToAddresses': [to_email]},
        Message={
            'Subject': {'Data': 'Processamento Lambda'},
            'Body': {'Text': {'Data': error_message}}
        }
    )

@patch('src.config.config.logger')
def test_send_email_notification_missing_credentials(mock_logger, ses_client_mock):
    # Arrange
    source_email = 'test-source@example.com'
    to_email = 'recipient@example.com'
    error_message = 'Sample error message'
    ses_client_mock.send_email.side_effect = NoCredentialsError()

    # Act & Assert
    with pytest.raises(NoCredentialsError):
        send_email_notification(source_email, to_email, error_message)

@patch('src.config.config.logger')
def test_send_email_notification_invalid_email(mock_logger, ses_client_mock):
    # Arrange
    source_email = 'test-source@example.com'
    to_email = 'invalid-email'
    error_message = 'Sample error message'
    ses_client_mock.send_email.side_effect = Exception("Invalid email address")

    # Act & Assert
    with pytest.raises(Exception) as exc_info:
        send_email_notification(source_email, to_email, error_message)

    assert "Invalid email address" in str(exc_info.value)