import os, psycopg
from flask import Flask, jsonify, request
app=Flask(__name__)
def connect(): return psycopg.connect(host='database',dbname='tasks',user='lab',password=os.environ['POSTGRES_PASSWORD'])
def setup(db): db.execute('CREATE TABLE IF NOT EXISTS tasks (id SERIAL PRIMARY KEY, title TEXT NOT NULL)')
@app.get('/tasks')
def tasks():
    with connect() as db:
        setup(db)
        return jsonify([dict(id=i,title=t) for i,t in db.execute('SELECT id,title FROM tasks ORDER BY id').fetchall()])
@app.post('/tasks')
def add():
    title=str((request.get_json(silent=True) or {}).get('title','')).strip()
    if not title: return jsonify(error='Title required'),400
    with connect() as db:
        setup(db)
        row=db.execute('INSERT INTO tasks(title) VALUES (%s) RETURNING id',(title,)).fetchone()
        return jsonify(id=row[0],title=title),201
if __name__=='__main__': app.run(host='0.0.0.0',port=5000)
