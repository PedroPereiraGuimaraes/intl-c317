import torch
from torch.utils.data import Dataset, DataLoader
from transformers import AutoModelForQuestionAnswering, AutoTokenizer, AdamW
from torch.optim import AdamW as TorchAdamW
from pymongo import MongoClient 

# Exemplo de uma classe de conjunto de dados personalizada
class QADataset(Dataset):
    def __init__(self, data, max_seq_length=512):
        self.data = data
        self.max_seq_length = max_seq_length
        self.tokenizer = AutoTokenizer.from_pretrained("bert-large-uncased-whole-word-masking-finetuned-squad")

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        question = self.data[idx]['question']
        answer = self.data[idx]['answer']

        # Truncate ou pad as sequências para o comprimento máximo
        inputs = self.tokenizer(question, answer, return_tensors="pt", max_length=self.max_seq_length, truncation=True, padding='max_length')
        
        return {
            'input_ids': inputs['input_ids'].squeeze(),
            'attention_mask': inputs['attention_mask'].squeeze(),
            'start_positions': torch.tensor([0]),  # Placeholder, você precisará ajustar isso conforme necessário
            'end_positions': torch.tensor([len(answer.split()) - 1])  # Placeholder, ajuste conforme necessário
        }

# Conectar ao MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client.dados_treinamento
collection = db.dados

# Exemplo de consulta ao MongoDB
data_from_mongo = list(collection.find({},{'_id': 0}))

# Verificar se o conjunto de dados não está vazio
if len(data_from_mongo) == 0:
    raise ValueError("O conjunto de dados MongoDB está vazio.")

# Criar um conjunto de dados
dataset = QADataset(data_from_mongo)

# Verificar se há documentos suficientes para formar um batch
batch_size = 3
if len(dataset) < batch_size:
    raise ValueError("Não há documentos suficientes para formar um batch.")

# Criar um DataLoader
dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

# Carregar o modelo pré-treinado para perguntas e respostas
model_name = "bert-large-uncased-whole-word-masking-finetuned-squad"
model = AutoModelForQuestionAnswering.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name) 

# Parâmetros de treinamento
optimizer = TorchAdamW(model.parameters(), lr=1e-5)
epochs = 3

# Treinamento
for epoch in range(epochs):
    for batch in dataloader:
        optimizer.zero_grad()
        outputs = model(**batch)
        loss = outputs.loss
        loss.backward()
        optimizer.step()

# Salvando o modelo treinado (opcional)
# model.save_pretrained('dados/modelo')
# dataset.tokenizer.save_pretrained('dados/tokenizer')

# Preparar uma pergunta e um contexto
question = "Qual e a capital do Brasil?"
context = "O Brasil é um país localizado na América do Sul, conhecido por suas vastas florestas tropicais e praias deslumbrantes."

# Tokenizar a pergunta e o contexto
inputs = dataset.tokenizer(question, context, return_tensors='pt', max_length=512, truncation=True)

# Realizar Inferência
with torch.no_grad():
    outputs = model(**inputs)

# Recuperar as posições iniciais e finais das respostas
start_logits = outputs.start_logits
end_logits = outputs.end_logits

# Encontrar a melhor resposta com base nas posições iniciais e finais
start_index = torch.argmax(start_logits)
end_index = torch.argmax(end_logits)

# Recuperar a resposta da tokenização original
answer_tokens = inputs['input_ids'][0][start_index:end_index+1]
answer = dataset.tokenizer.decode(answer_tokens, skip_special_tokens=True)


# Imprimir a resposta
print("Pergunta:", question)
print("Resposta Gerada pelo Modelo:", answer_tokens)