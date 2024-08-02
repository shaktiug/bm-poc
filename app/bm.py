from flask import Flask, jsonify
import psycopg2
from psycopg2 import OperationalError
import configparser

bm = Flask(__name__)

# Read MySQL configuration from config.ini
config = configparser.ConfigParser()
config.read('config.ini')

db_config = {
    'user': config['postgres']['user'],
    'password': config['postgres']['password'],
    'host': config['postgres']['host'],
    'database': config['postgres']['database']
}

# Function to get a database connection
def get_db_connection():
    conn = psycopg2.connect(**db_config)
    return conn

@bm.route('/live', methods=['GET'])
def check_db_connection():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({'message': 'Well done'})
    except OperationalError as err:
        return jsonify({'message': 'Maintenance'}), 500
    
if __name__ == '__main__':
    bm.run(debug=True)
