import os
from dotenv import load_dotenv
import textwrap
import google.generativeai as genai
from IPython.display import display
from IPython.display import Markdown

load_dotenv()
GOOGLE_API_KEY=os.environ.get('GOOGLE_API_KEY')
genai.configure(
  api_key=GOOGLE_API_KEY
)


def to_markdown(text):
  text = text.replace('•', '  *')
  return Markdown(textwrap.indent(text, '> ', predicate=lambda _: True))

model = genai.GenerativeModel('gemini-pro')

#MENU

while True:
    escolha = input('Escolha a opção pergunta[2] ou sair[1]: ')

    if escolha != '1':
        pergunta = input('Digite sua pergunta: ')
        chat = model.start_chat(history=[])
        response = chat.send_message(pergunta)

        response.resolve()
        print(response.text)
        print("")
    else:
        print('Obrigado!')
        break


