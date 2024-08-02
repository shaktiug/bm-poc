import unittest
from unittest.mock import patch, MagicMock
import bm

class TestBMApp(unittest.TestCase):

    def setUp(self):
        self.bm = bm.test_client()
        self.bm.testing = True

    @patch('bm.get_db_connection')
    def test_live_endpoint_status_success(self, mock_get_live_endpoint_status):
        # Mock the database connection to return a successful connection
        mock_conn = MagicMock()
        mock_get_live_endpoint_status = mock_conn

        response = self.bm.get('/live')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, {'message': 'Well done'})

    @patch('bm.get_db_connection')
    def test_live_endpoint_status_failure(self, mock_get_live_endpoint_status):
        # Mock the database connection to return a successful connection
    
        mock_get_live_endpoint_status.side_effect = Exception('Maintenance')

        response = self.bm.get('/live')
        self.assertEqual(response.status_code, 500)
        self.assertEqual(response.json, {'message': 'Maintenance'})

if __name__ == '__main__':
    unittest.main()