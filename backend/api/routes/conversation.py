import random
from flask import Blueprint, jsonify, request
import google.generativeai as genai
import datetime
import os
from dotenv import load_dotenv
from database.db_connection import Database

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

db_conversation = Database(database="chat", collection="conversation")
db_prompt_parts = Database(database="chat", collection="prompt_parts")

def verifychat():
      while True:
        chatId = random.randint(0, 99999999)
        existing_chat = db_conversation.collection.find_one({"chatId": chatId})
        if not existing_chat:
          return chatId 

# CREATE CHAT
@routes_conversation.route('/chat/create', methods=['POST'])
def criar_chat():
    data = request.json
    chatId = verifychat()
    userId = data['userId']
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    db_conversation.collection.insert_one({
        'chatId': chatId,
        'userId': userId,
        'messages': [{"idUser": userId, "message": "", "response": "Olá, como posso ajudá-lo!", "timestamp": timestamp}],
    })

    chats = list(db_conversation.collection.find({'chatId': chatId}, {'_id': 0}))
    
    return jsonify(chats), 201

# GET CHATS BY ID
@routes_conversation.route('/chats/user/<userId>', methods=['GET'])
def get_chats_by_user(userId):
    chats = list(db_conversation.collection.find({'userId': userId}, {'_id': 0}))
    return jsonify(chats), 200


# GET CHAT MESSAGES BY CHAT ID
@routes_conversation.route('/chats/user/messages/<chatId>', methods=['GET'])
def get_chat_messages_by_chat_id(chatId):
    chatId = int(chatId)
    chat = db_conversation.collection.find_one({'chatId': chatId}, {'_id': 0})
    if chat:
        messages = chat.get('messages', [])
        return jsonify(messages), 200
    else:
        return jsonify({'error': 'Chat not found'}), 404
    
# GET ALL CHAT MESSAGES BY CHAT ID
@routes_conversation.route('/chats/user/messages/<chatId>', methods=['GET'])
def get_all_chat_messages_by_chat_id(chatId):
  chatId = int(chatId)
  chat = db_conversation.collection.find_one({'chatId': chatId}, {'_id': 0})
  if chat:
    messages = chat.get('messages', [])
    if messages:
      # Sort messages by timestamp in descending order (newest first)
      messages.sort(key=lambda message: message.get('timestamp'), reverse=True)
      return jsonify(messages), 200
    else:
      return jsonify({'message': 'Chat has no messages'}), 200  # Informative message
  else:
    return jsonify({'error': 'Chat not found'}), 404


# SEND MESSAGE
@routes_conversation.route('/chat/sendquestion', methods=['POST'])
def receive_message():
    try:
        data = request.json

        # Validar se todos os campos necessários estão presentes no request
        if 'chatId' not in data or 'userId' not in data or 'message' not in data:
            return jsonify({"error": "Missing required fields"}), 400

        chatId = int(data['chatId'])
        userId = data['userId']
        message = data['message']
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        response = process_message(message)

        # Verificar se o chatId existe no banco de dados antes de atualizar
        if db_conversation.collection.count_documents({'chatId': chatId}) == 0:
            return jsonify({"error": "Chat ID not found"}), 404

        # Atualizar a coleção com a nova mensagem
        db_conversation.collection.update_one(
            {'chatId': chatId},
            {'$push': {'messages': {'userId': userId, 'message': message, 'response': response, 'timestamp': timestamp}}}
        )

        return jsonify({"response": response}), 200

    except ValueError:
        return jsonify({"error": "Invalid chatId format"}), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# DELETE CHAT BY ID
@routes_conversation.route('/chat/delete/<chatId>', methods=['DELETE'])
def delete_chat_by_id(chatId):
    chatId = int(chatId)
    deleted_chat = db_conversation.collection.delete_one({'chatId': chatId})
    if deleted_chat.deleted_count == 1:
        return jsonify({'message': 'Chat deleted successfully'}), 200
    else:
        return jsonify({'error': 'Chat not found'}), 404


def process_message(message):
  try:
    documento = db_prompt_parts.collection.find_one({'name': 'dados_treinamento'})

    if documento:
      prompt_parts = documento['prompt_parts']
      prompt_parts.append("User: "+ message)
      response = model.generate_content(prompt_parts)   
      responseText = response.candidates[0].content.parts[0].text
      return str(responseText)
    else:
      print("Documento 'dados_treinamento' não encontrado.")

  except Exception as e:
    print(f"Erro ao adicionar elemento ao final da lista: {e}")