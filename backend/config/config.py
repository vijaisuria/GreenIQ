import os
class Config:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    FIREBASE_CREDENTIALS = os.path.join(BASE_DIR, '..', 'config', 'firebase_admin.json')
    FIREBASE_COLLECTION = "users"