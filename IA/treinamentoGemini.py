import google.generativeai as genai
from pymongo import MongoClient
from flask import Flask, request, jsonify
import datetime
import os
from dotenv import load_dotenv
from bson import ObjectId

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

app = Flask(__name__)

# Rotas da API para dados da IA

@app.route('/dadosTreinamento', methods=['GET'])
def get_perguntas():
    dadosTreinamento = list(collection.find({}, {'_id': 0,'prompt_parts':1}))
    return jsonify(dadosTreinamento)

@app.route('/conversations', methods=['GET'])
def get_conversas():
    conversas = list(conversation_collection.find({}, {'_id': 0}))
    print(conversas)
    return jsonify(conversas)

@app.route('/enviarPergunta', methods=['POST'])
def receive_message():
    data = request.json
    message = data['message']
    response = process_message(message)
    conversation_collection.insert_one({
        'message': message,
        'bot_response': response,
        'timestamp': datetime.datetime.now()
    })
    return response

def process_message(message):
    response = model.generate_content(message)
    responseText = response.candidates[0].content.parts[0].text
    return str(responseText)

# Rotas da API para usuarios
db = client['google_db']
users_collection = db['users']
# Rota para criar um novo usuário
@app.route('/user', methods=['POST'])
def create_user():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    if username and password:
        user_id = users_collection.insert_one({'username': username, 'password': password}).inserted_id
        return jsonify({'message': 'User created successfully', 'user_id': str(user_id)}), 201
    else:
        return jsonify({'error': 'Username and password are required'}), 400

# Rota para obter todos os usuários
@app.route('/users', methods=['GET'])
def get_users():
    users = []
    for user in users_collection.find():
        users.append({'_id': str(user['_id']), 'username': user['username']})
    return jsonify(users)

# Rota para obter um usuário por ID
@app.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    user = users_collection.find_one({'_id': ObjectId(user_id)})
    if user:
        return jsonify({'_id': str(user['_id']), 'username': user['username']})
    else:
        return jsonify({'error': 'User not found'}), 404

# Rota para atualizar um usuário
@app.route('/user/<user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.json
    username = data.get('username')
    password = data.get('password')
    if username and password:
        updated_user = users_collection.update_one({'_id': ObjectId(user_id)}, {'$set': {'username': username, 'password': password}})
        if updated_user.modified_count:
            return jsonify({'message': 'User updated successfully'})
        else:
            return jsonify({'error': 'User not found'}), 404
    else:
        return jsonify({'error': 'Username and password are required'}), 400

# Rota para excluir um usuário
@app.route('/user/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    deleted_user = users_collection.delete_one({'_id': ObjectId(user_id)})
    if deleted_user.deleted_count:
        return jsonify({'message': 'User deleted successfully'})
    else:
        return jsonify({'error': 'User not found'}), 404




if __name__ == '__main__':
    app.run(debug=True)




# response = model.generate_content(prompt_parts)
# print(response.text)