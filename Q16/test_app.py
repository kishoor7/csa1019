import unittest
from app import app, tasks
class TodoTests(unittest.TestCase):
    def test_workflow(self):
        tasks.clear()
        c=app.test_client()
        self.assertEqual(c.post('/tasks',json={'title':'Study Docker'}).status_code,201)
        self.assertFalse(c.get('/tasks').get_json()[0]['done'])
        self.assertTrue(c.patch('/tasks/1').get_json()['done'])
        self.assertEqual(c.post('/tasks',json={}).status_code,400)
if __name__=='__main__': unittest.main()
