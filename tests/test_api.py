from urllib import response
from fastapi import FastAPI
from fastapi.testclient import TestClient

from api.main import app

client = TestClient(app)

def test_main():

    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "API is running"}