import random
from flask import Blueprint, jsonify, request
from pymongo import MongoClient
import google.generativeai as genai
import datetime
import os
from dotenv import load_dotenv

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
conversation_collection = db['conversation']

def verifychat():
      while True:
        chatId = random.randint(0, 99999999)
        existing_chat = conversation_collection.find_one({"chatId": chatId})
        if not existing_chat:
          return chatId 

# CREATE CHAT
@routes_conversation.route('/chat/create', methods=['POST'])
def criar_chat():
    data = request.json
    chatId = verifychat()
    userId = data['userId']
    
    conversation_collection.insert_one({
        'chatId': chatId,
        'userId': userId,
    })
    
    response_data = {
      'message': 'Chat created successfully',
      'chatId': chatId
    }
    return jsonify(response_data), 201

# GET CHATS BY ID
@routes_conversation.route('/chats/user', methods=['GET'])
def get_chats_by_user():
    data = request.json
    userId = data['userId']
    chats = list(conversation_collection.find({'userId': userId}, {'_id': 0}))
    return jsonify(chats)

# SEND MESSAGE
@routes_conversation.route('/chat/sendquestion', methods=['POST'])
def receive_message():
    data = request.json
    chatId = data['chatId']
    userId = data['userId']
    message = data['message']
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    response = process_message(message)
    
    conversation_collection.update_one(
        {'chatId': chatId},
        {'$push': {'messages': {'idUser': userId, 'message': message,'response':response, 'timestamp': timestamp}}}
    )
    
    return jsonify({"response": response})


def process_message(message):
    response = model.generate_content(message)
    responseText = response.candidates[0].content.parts[0].text
    return str(responseText)