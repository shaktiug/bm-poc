from flask import Flask, jsonify
import mysql.connector
import configparser

app = Flask(__name__)

# Read MySQL configuration from config.ini
config = configparser.ConfigParser()
config.read('config.ini')

db_config = {
    'user': config['mysql']['user'],
    'password': config['mysql']['password'],
    'host': config['mysql']['host'],
    'database': config['mysql']['database']
}

# Function to get a database connection
def get_db_connection():
    conn = mysql.connector.connect(**db_config)
    return conn

@app.route('/live', methods=['GET'])
def check_db_connection():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({'message': 'Well done'})
    except mysql.connector.Error as err:
        return jsonify({'message': str(err)}), 500
    
if __name__ == '__main__':
    app.run(debug=True)
