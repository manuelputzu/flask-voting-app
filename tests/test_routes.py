import sys
import os

# Add parents directory to Python's path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app

def test_home_route():
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b'Vote' in response.data
    