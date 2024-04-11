from flask import Flask

from routes.conversation import routes_conversation
from routes.user import routes_user

app = Flask(__name__)

app.register_blueprint(routes_conversation)
app.register_blueprint(routes_user)


if __name__ == '__main__':
    app.run(debug=True)