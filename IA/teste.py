import google.generativeai as genai
from pymongo import MongoClient
from flask import Flask, request, jsonify
import datetime

genai.configure(api_key="-")

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

model = genai.GenerativeModel(model_name="gemini-1.0-pro",
                              generation_config=generation_config,
                              safety_settings=safety_settings)

client = MongoClient('localhost', 27017)
db = client['google_db']
collection = db['prompt_parts']
conversation_collection = db['conversation']

lista_db = list(collection.find({},{"_id":0, "prompt_parts":1}))
prompt_parts = lista_db[0]['prompt_parts'] 

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(debug=True)

# response = model.generate_content(prompt_parts)
# print(response.text)