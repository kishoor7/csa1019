from flask import Flask, jsonify
app = Flask(__name__)
@app.get('/')
def home(): return jsonify(message='Software Engineering Lab API', status='running')
@app.get('/health')
def health(): return jsonify(status='ok')
@app.get('/hello/<name>')
def hello(name): return jsonify(message=f'Hello, {name}')
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000)
