from flask import Flask
from routes.user import routes_user
from routes.conversation import routes_conversation
from flask_swagger_ui import get_swaggerui_blueprint
from flask_cors import CORS

swagger_url="/docs"
api_url="/static/swagger.json"

app = Flask(__name__)

swagger = get_swaggerui_blueprint(
    swagger_url,
    api_url,
    config={
        'app_name': 'API chatbot'
    }
)
# Permitindo solicitações de todas as origens
CORS(app, resources={r"/*": {"origins": "*"}})

# Habilitar CORS para todas as rotas
CORS(app)

app.register_blueprint(swagger, url_prefix=swagger_url)
app.register_blueprint(routes_conversation)
app.register_blueprint(routes_user)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)