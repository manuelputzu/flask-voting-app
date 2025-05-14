from flask import Flask, render_template, request, make_response
from flask_sqlalchemy import SQLAlchemy
import random
import os

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///votes.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

# Voting options
option_a = "True"
option_b = "False"

# Define Vote model
class Vote(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    voter_id = db.Column(db.String(100), unique=True, nullable=False)
    vote = db.Column(db.String(10), nullable=False)

def create_tables():
    with app.app_context():
        db.create_all()

@app.route("/", methods=["GET", "POST"])
def home():
    vote = None
    voter_id = request.cookies.get("voter_id")
    if not voter_id:
        voter_id = str(random.getrandbits(64))

    existing_vote = Vote.query.filter_by(voter_id=voter_id).first()

    if request.method == "POST":
        selected_vote = request.form["vote"]
        if existing_vote:
            existing_vote.vote = selected_vote  # Update existing vote
        else:
            new_vote = Vote(voter_id=voter_id, vote=selected_vote)
            db.session.add(new_vote)
        db.session.commit()
        vote = selected_vote
    elif existing_vote:
        vote = existing_vote.vote

    resp = make_response(render_template(
        "index.html",
        option_a=option_a,
        option_b=option_b,
        vote=vote
    ))
    resp.set_cookie("voter_id", voter_id)
    return resp

if __name__ == "__main__":
    create_tables()
    app.run(debug=True)

