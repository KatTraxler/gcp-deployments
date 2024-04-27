from email import header
import os
import urllib.request
import urllib.parse
import shutil
import google.auth
from google.auth import compute_engine
import google.auth.transport.requests
from flask import Flask, json, request, abort, jsonify
import requests as requests
import subprocess
import shutil
from subprocess import run

app = Flask(__name__)


@app.route('/', methods=['GET'])
def get_access_token():

  METADATA_HEADERS = {'Metadata-Flavor': 'Google'}
  url = 'http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token'

  # Request an access token from the metadata server.
  r = requests.get(url, headers=METADATA_HEADERS)
  r.raise_for_status()

  # Extract the access token from the response.
  access_token = r.json()['access_token']
  print(access_token)
  return access_token, 200, {'Content-Type': 'application/json; charset=utf-8'}  

@app.errorhandler(400)
def handle_400_error(e):
    raise Exception("Unhandled Exception")