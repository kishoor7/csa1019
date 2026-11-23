from flask import Flask, jsonify, request
app = Flask(__name__)
tasks = []
@app.get('/')
@app.get('/tasks')
def list_tasks(): return jsonify(tasks)
@app.post('/tasks')
def create():
    title = str((request.get_json(silent=True) or {}).get('title','')).strip()
    if not title: return jsonify(error='Title required'),400
    task = dict(id=len(tasks)+1,title=title,done=False)
    tasks.append(task)
    return jsonify(task),201
@app.patch('/tasks/<int:task_id>')
def complete(task_id):
    task = next((x for x in tasks if x['id']==task_id),None)
    if task is None: return jsonify(error='Not found'),404
    task['done']=True
    return jsonify(task)
if __name__ == '__main__': app.run(host='0.0.0.0', port=5000)
