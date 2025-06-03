from flask import Flask, render_template, request, make_response
import mysql.connector
import random
import os
from dotenv import load_dotenv
load_dotenv() # load environment variables from .env
import logging
from logging.handlers import RotatingFileHandler


# environment variables 
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

if not all([DB_HOST, DB_NAME, DB_USER, DB_PASS]):
    raise ValueError("Missing required database environment variables.")

def get_db_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        database=DB_NAME,
        connection_timeout=5
    )

app = Flask(__name__)

# Configure Logging
if not os.path.exists('logs'):
    os.mkdir('logs')

file_handler = RotatingFileHandler('logs/app.log', maxBytes=10240, backupCount=3)
file_handler.setLevel(logging.INFO)
file_handler.setFormatter(logging.Formatter(
    '%(asctime)s [%(levelname)s] %(message)s'
))
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)
app.logger.info("Voting App startup")


# Voting options
option_a = "True"
option_b = "False"

@app.route("/", methods=["GET", "POST"])
def home():
    print("DB_HOST:", DB_HOST)

    vote = None
    voter_id = request.cookies.get("voter_id")

    if not voter_id:
        voter_id = str(random.getrandbits(64))

    if request.method == "POST":
        vote = request.form.get("vote")

        conn = None
        try:
            conn = get_db_connection()
            cur = conn.cursor(dictionary=True)

            # Check for existing vote
            cur.execute("SELECT * FROM votes WHERE voter_id = %s", (voter_id,))
            existing_vote = cur.fetchone()

            if not existing_vote:
                cur.execute(
                    "INSERT INTO votes (voter_id, vote) VALUES (%s, %s)",
                    (voter_id, vote)
                )
                conn.commit()

        except mysql.connector.Error as err:
            app.logger.error(f"Database error: {err}")
        finally:
            if conn:
                conn.close()

    response = make_response(render_template(
        "index.html",
        option_a=option_a,
        option_b=option_b,
        vote=vote
    ))
    response.set_cookie("voter_id", voter_id)
    return response

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
