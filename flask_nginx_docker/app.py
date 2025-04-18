from flask import Flask, jsonify
import datetime
import platform
import os

app = Flask(__name__)


@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Not found", "status": 404}), 404


@app.errorhandler(500)
def server_error(e):
    return jsonify({"error": "Internal server error", "status": 500}), 500


@app.route("/")
def home():
    try:
        return jsonify(
            {
                "message": "Welcome to Flask API",
                "status": "running",
                "timestamp": datetime.datetime.now().isoformat(),
            }
        )
    except Exception as e:
        app.logger.error(f"Error in home route: {str(e)}")
        return jsonify({"error": "Internal server error", "status": 500}), 500


@app.route("/health")
def health():
    try:
        return jsonify(
            {"status": "healthy", "timestamp": datetime.datetime.now().isoformat()}
        )
    except Exception as e:
        app.logger.error(f"Error in health route: {str(e)}")
        return jsonify({"error": "Service unhealthy", "status": 503}), 503


@app.route("/info")
def info():
    try:
        return jsonify(
            {
                "app_name": "Flask API Demo",
                "version": "1.0.0",
                "python_version": platform.python_version(),
                "environment": os.getenv("FLASK_ENV", "production"),
            }
        )
    except Exception as e:
        app.logger.error(f"Error in info route: {str(e)}")
        return jsonify({"error": "Internal server error", "status": 500}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
