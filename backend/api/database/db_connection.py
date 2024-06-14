from dotenv import load_dotenv
import pymongo
import os

load_dotenv()

class Database:
    def __init__(self, database, collection):
        self.connect(database, collection) 

    def connect(self, database, collection):
        try:
            connectionString = f"mongodb+srv://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@chat.p9ry4af.mongodb.net/?retryWrites=true&w=majority&appName=chat"
            self.clusterConnection = pymongo.MongoClient(
                connectionString,
                tlsAllowInvalidCertificates=True 
            )
            self.db = self.clusterConnection[database] 
            self.collection = self.db[collection] 
            print("Conectado ao banco de dados com sucesso!")
        except Exception as e:
            print(e)