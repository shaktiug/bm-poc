import unittest
from unittest.mock import patch, MagicMock
from bm import bm

class TestBMApp(unittest.TestCase):

    def setUp(self):
        self.bm = bm.test_client()
        self.bm.testing = True

    @patch('bm.get_db_connection')
    def test_live_endpoint_status_success(self, mock_get_db_connection):
        # Mock the database connection to return a successful connection
        mock_conn = MagicMock()
        mock_get_db_connection.return_value = mock_conn

        response = self.bm.get('/live')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, {'message': 'Well done'})

    @patch('bm.get_db_connection')
    def test_live_endpoint_status_failure(self, mock_get_db_connection):
        # Mock the database connection to return a successful connection

        mock_get_db_connection.side_effect = Exception('Maintenance')

        response = self.bm.get('/live')
        self.assertEqual(response.status_code, 500)

if __name__ == '__main__':
    unittest.main()