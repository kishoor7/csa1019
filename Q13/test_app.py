import unittest
from app import app
class ApiTests(unittest.TestCase):
    def test_health(self): self.assertEqual(app.test_client().get('/health').get_json(), {'status':'ok'})
    def test_home(self): self.assertEqual(app.test_client().get('/').get_json()['status'], 'running')
    def test_hello(self): self.assertEqual(app.test_client().get('/hello/Student').get_json(), {'message':'Hello, Student'})
if __name__ == '__main__': unittest.main()
