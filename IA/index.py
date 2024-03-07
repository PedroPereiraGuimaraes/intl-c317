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

pergunta = input('Digite sua pergunta: ')

response = model.generate_content(pergunta)

print(response.text)
