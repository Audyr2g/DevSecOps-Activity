import pytest
import sys
import os

# Ensure the app module can be found
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from app.main import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    response = client.get('/api/health')
    assert response.status_code == 200
    assert response.get_json() == {"status": "healthy"}

def test_hello_world(client):
    response = client.get('/api/hello')
    assert response.status_code == 200
    assert response.get_json() == {"message": "Hello, Secure World!"}
    
def test_server_header_removed(client):
    response = client.get('/api/health')
    assert response.headers.get('Server') == 'Secure-API'