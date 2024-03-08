import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader

# Exemplo geral de como você pode começar a treinar um modelo de linguagem simples usando PyTorch.

# Classe do modelo de linguagem
class SimpleLanguageModel(nn.Module):
    def __init__(self, vocab_size, embedding_dim, hidden_dim):
        super(SimpleLanguageModel, self).__init__()
        self.embedding = nn.Embedding(vocab_size, embedding_dim)
        self.lstm = nn.LSTM(embedding_dim, hidden_dim, batch_first=True)
        self.fc = nn.Linear(hidden_dim, vocab_size)

    def forward(self, x):
        embedded = self.embedding(x)
        lstm_out, _ = self.lstm(embedded)
        output = self.fc(lstm_out)
        return output

# Função para treinar o modelo
def train_model(model, dataloader, criterion, optimizer, epochs=5):
    model.train()
    for epoch in range(epochs):
        for inputs, targets in dataloader:
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs.view(-1, outputs.size(2)), targets.view(-1))
            loss.backward()
            optimizer.step()
        print(f'Epoch {epoch + 1}/{epochs}, Loss: {loss.item()}')

# Dados fictícios (substitua por seus próprios dados)
class SimpleDataset(Dataset):
    def __init__(self, data):
        self.data = data

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        return torch.LongTensor(self.data[idx]), torch.LongTensor(self.data[idx])

# Hiperparâmetros
vocab_size = 10000
embedding_dim = 128
hidden_dim = 256
batch_size = 32

# Criação do modelo
model = SimpleLanguageModel(vocab_size, embedding_dim, hidden_dim)

# Dados fictícios (substitua por seus próprios dados)
data = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10],[6, 7, 8, 9, 10],[6, 7, 8, 9, 10]]
dataset = SimpleDataset(data)
dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

# Função de perda e otimizador
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Treinamento do modelo
train_model(model, dataloader, criterion, optimizer, epochs=80)