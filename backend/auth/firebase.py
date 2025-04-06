import firebase_admin
from firebase_admin import credentials, firestore
from config.config import Config

cred = credentials.Certificate(Config.FIREBASE_CREDENTIALS)
firebase_admin.initialize_app(cred)
db = firestore.client()
users_collection = db.collection(Config.FIREBASE_COLLECTION)