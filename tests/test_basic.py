import sys
import os

# Add the parent directory (where app.py lives) to Python's path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app

def test_homepage_loads():
    with app.test_client() as client:
        response = client.get("/")
        assert response.status_code == 200
        assert b"Vote" in response.data  # Looks for the word "Vote" in the page
