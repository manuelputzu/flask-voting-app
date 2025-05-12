from flask import Flask, render_template, request, make_response
import random

app = Flask(__name__)

option_a = "True"
option_b = "False"

@app.route("/", methods=["GET", "POST"])
def home():
    vote = None
    voter_id = request.cookies.get("voter_id")
    if not voter_id:
        voter_id = str(random.getrandbits(64))

    if request.method == "POST":
        vote = request.form["vote"]

    resp = make_response(render_template(
        "index.html",
        option_a=option_a,
        option_b=option_b,
        vote=vote
    ))
    resp.set_cookie("voter_id", voter_id)
    return resp

if __name__ == "__main__":
    app.run(debug=True)

