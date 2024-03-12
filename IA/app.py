from flask import Flask, request, jsonify
import torch
from treinamento import SimpleLanguageModel
from treinamento import model
app = Flask(__name__)

optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

# Carregue o modelo treinado
checkpoint = torch.load('modelo.pth')
model = SimpleLanguageModel(checkpoint['vocab_size'], checkpoint['embedding_dim'], checkpoint['hidden_dim'])
model.load_state_dict(checkpoint['model_state_dict'])
optimizer.load_state_dict(checkpoint['optimizer_state_dict'])

model.eval()

@app.route('/', methods=['GET'])
def home():
    return "Bem-vindo ao seu modelo de linguagem!"

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        input_sequence = data['input_sequence']

        # Converta as strings em números inteiros
        input_sequence = [int(item) for item in input_sequence]

        # Carregue o modelo treinado
        checkpoint = torch.load('modelo.pth')
        model.load_state_dict(checkpoint['model_state_dict'])
        optimizer.load_state_dict(checkpoint['optimizer_state_dict'])

        # Execute a inferência no modelo
        with torch.no_grad():
            input_tensor = torch.LongTensor(input_sequence).unsqueeze(0)
            output = model(input_tensor)

        # Converta a saída para uma lista
        output_sequence = output.argmax(dim=-1).squeeze().tolist()

        return jsonify({'output_sequence': output_sequence})

    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)