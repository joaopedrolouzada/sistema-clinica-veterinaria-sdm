from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def status():
    return jsonify({"mensagem": "API do governo funcionando"})


if __name__ == "__main__":
    app.run(port=5001, debug=True)
