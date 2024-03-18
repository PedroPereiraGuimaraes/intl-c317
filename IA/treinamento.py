from flask import Flask, request, jsonify
from pymongo import MongoClient
import datetime
from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

# isso aqui só precisa para corrigir o bug
from spacy.cli import download

download("en_core_web_sm")

class ENGSM:
    ISO_639_1 = 'en_core_web_sm'

chatbot = ChatBot("BotLira",tagger_language=ENGSM)
client = MongoClient('localhost', 27017)
db = client['chatbot_db']
collection = db['database']

# Recuperar perguntas e respostas do MongoDB
conversas = []
for document in collection.find():
    conversas.append(document['pergunta'])
    conversas.append(document['resposta'])

# Treinar chatbot com as perguntas e respostas recuperadas
trainer = ListTrainer(chatbot)
trainer.train(conversas)

app = Flask(__name__)

conversation_collection = db['conversations']


@app.route('/perguntas', methods=['GET'])
def get_perguntas():
    perguntas = list(collection.find({}, {'_id': 0,'pergunta':1}))
    print(perguntas)
    return jsonify(perguntas)

@app.route('/conversations', methods=['GET'])
def get_conversas():
    conversas = list(conversation_collection.find({}, {'_id': 0}))
    print(conversas)
    return jsonify(conversas)

@app.route('/receive_message', methods=['POST'])
def receive_message():
    data = request.json
    message = data['message']
    # Aqui você processa a mensagem recebida pelo cliente e obtém a resposta do bot
    response = process_message(message)
    # Salva a conversa no MongoDB
    conversation_collection.insert_one({
        'message': message,
        'bot_response': response,
        'timestamp': datetime.datetime.now()
    })
    return response

def process_message(message):
    response = chatbot.get_response(message)
    return str(response)

if __name__ == '__main__':
    app.run(debug=True)