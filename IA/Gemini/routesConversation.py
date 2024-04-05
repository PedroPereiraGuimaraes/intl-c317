from flask import Blueprint, jsonify, request
from pymongo import MongoClient
import google.generativeai as genai
import datetime
import os
from dotenv import load_dotenv

# Criar um Blueprint para definir as rotas
routes_conversation = Blueprint('routes1', __name__)

load_dotenv()

api_key = os.getenv('API_KEY')

genai.configure(api_key=api_key)

# Set up the model
generation_config = {
  "temperature": 0.5,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
} 

safety_settings = [
  {
    "category": "HARM_CATEGORY_HARASSMENT",
    "threshold": "BLOCK_LOW_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_HATE_SPEECH",
    "threshold": "BLOCK_LOW_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
    "threshold": "BLOCK_LOW_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
    "threshold": "BLOCK_LOW_AND_ABOVE"
  },
]

model = genai.GenerativeModel(model_name="gemini-1.0-pro-001",
                              generation_config=generation_config,
                              safety_settings=safety_settings)

client = MongoClient('localhost', 27017)
db = client['google_db']
collection = db['prompt_parts']
conversation_collection = db['conversation']

lista_db = list(collection.find({},{"_id":0, "prompt_parts":1}))
prompt_parts = lista_db[0]['prompt_parts'] 

@routes_conversation.route('/conversations', methods=['GET'])
def get_conversas():
    conversas = list(conversation_collection.find({}, {'_id': 0}))
    return jsonify(conversas)

# Rotas da API para dados da IA
@routes_conversation.route('/dadosTreinamento', methods=['GET'])
def get_perguntas():
    dadosTreinamento = list(collection.find({}, {'_id': 0,'prompt_parts':1}))
    return jsonify(dadosTreinamento)

# Rota para criar um novo chat
@routes_conversation.route('/criarChat', methods=['POST'])
def criar_chat():
    data = request.json
    chatId = data['chatId']
    userId = data['userId']
    message = data['message']
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Criar um novo documento para o chat
    conversation_collection.insert_one({
        'chatId': chatId,
        'messages': [{'idUser': userId, 'message': message, 'response':"",'timestamp': timestamp}]
    })
    
    return jsonify({"mensagem": "Chat criado com sucesso!"})

# Chat ja criado, fazer pergunta
@routes_conversation.route('/enviarPergunta/<chatId>/<UserId>', methods=['POST'])
def receive_message(chatId, UserId):
    data = request.json
    idUser = UserId
    message = data['message']
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    response = process_message(message)
    
    # Atualizar o documento existente correspondente ao chatId
    conversation_collection.update_one(
        {'chatId': chatId},
        {'$push': {'messages': {'idUser': idUser, 'message': message,'response':response, 'timestamp': timestamp}}}
    )
    
    return jsonify({"response": response})


def process_message(message):
    response = model.generate_content(message)
    responseText = response.candidates[0].content.parts[0].text
    return str(responseText)