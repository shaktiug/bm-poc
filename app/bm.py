from flask import Flask, jsonify
import mysql.connector
import configparser

app = Flask(__name__)

# Read MySQL configuration from config.ini
config = configparser.ConfigParser()
config.read('config.ini')
