from flask import Flask
from routes.user import routes_user
from routes.conversation import routes_conversation
from flask_swagger_ui import get_swaggerui_blueprint

swagger_url="/swagger"
api_url="/static/swagger.json"

app = Flask(__name__)

swagger = get_swaggerui_blueprint(
    swagger_url,
    api_url,
    config={
        'app_name': 'API chatbot'
    }
)

app.register_blueprint(swagger, url_prefix=swagger_url)
app.register_blueprint(routes_conversation)
app.register_blueprint(routes_user)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)