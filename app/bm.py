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