from flask import Flask

from routesConversation import routes_conversation
from routesUser import routes_user

app = Flask(__name__)

# Registrar o Blueprint com as rotas
app.register_blueprint(routes_conversation)
app.register_blueprint(routes_user)


if __name__ == '__main__':
    app.run(debug=True)

# response = model.generate_content(prompt_parts)
# print(response.text)