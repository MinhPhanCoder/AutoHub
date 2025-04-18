from flask import Flask, jsonify
import datetime
import platform
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to Flask API",
        "timestamp": datetime.datetime.now().isoformat(),
        "hostname": platform.node()
    })

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.datetime.now().isoformat()
    })

@app.route('/info')
def info():
    return jsonify({
        "python_version": platform.python_version(),
        "platform": platform.platform(),
        "environment": os.getenv("FLASK_ENV", "production")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)