import os
from flask import Flask, jsonify

app = Flask(__name__)

# Security best practice: Remove server identifying headers
@app.after_request
def remove_server_header(response):
    response.headers['Server'] = 'Secure-API'
    return response

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint for container orchestration readiness probes."""
    return jsonify({"status": "healthy"}), 200

@app.route('/api/hello', methods=['GET'])
def hello_world():
    """Primary application endpoint."""
    return jsonify({"message": "Hello, Secure World!"}), 200

if __name__ == '__main__':
    # Fallback for local testing; Dockerfile will use gunicorn
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)