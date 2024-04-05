from pymongo import MongoClient
from flask import Blueprint, jsonify, request
from bson import ObjectId

# Criar um Blueprint para definir as rotas
routes_user = Blueprint('routes2', __name__)

# Rotas da API para usuarios
client = MongoClient('localhost', 27017)
db = client['google_db']
users_collection = db['users']

# Rota para criar um novo usuário
@routes_user.route('/user', methods=['POST'])
def create_user():
    data = request.json
    email = data.get('email')
    username = data.get('username')
    password = data.get('password')

    if username and password:
        user_id = users_collection.insert_one({'username': username, 'password': password ,'email': email}).inserted_id
        return jsonify({'message': 'User created successfully', 'user_id': str(user_id)}), 201
    else:
        return jsonify({'error': 'Username and password are required'}), 400

# Rota para obter todos os usuários
@routes_user.route('/users', methods=['GET'])
def get_users():
    users = []
    for user in users_collection.find():
        users.append({'_id': str(user['_id']), 'username': user['username']})
    return jsonify(users)

# Rota para obter um usuário por ID
@routes_user.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    user = users_collection.find_one({'_id': ObjectId(user_id)})
    if user:
        return jsonify({'_id': str(user['_id']), 'username': user['username']})
    else:
        return jsonify({'error': 'User not found'}), 404

# Rota para atualizar um usuário
@routes_user.route('/user/<user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.json
    username = data.get('username')
    password = data.get('password')
    if username and password:
        updated_user = users_collection.update_one({'_id': ObjectId(user_id)}, {'$set': {'username': username, 'password': password}})
        if updated_user.modified_count:
            return jsonify({'message': 'User updated successfully'})
        else:
            return jsonify({'error': 'User not found'}), 404
    else:
        return jsonify({'error': 'Username and password are required'}), 400

# Rota para excluir um usuário
@routes_user.route('/user/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    deleted_user = users_collection.delete_one({'_id': ObjectId(user_id)})
    if deleted_user.deleted_count:
        return jsonify({'message': 'User deleted successfully'})
    else:
        return jsonify({'error': 'User not found'}), 404


