from flask import Blueprint, jsonify, request
from database.db_connection import Database
from bson import ObjectId

routes_user = Blueprint('routes2', __name__)

db = Database(database="chat", collection="users")

# LOGIN USER
@routes_user.route('/user/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if email and password:
        user = db.collection.find_one({'email': email, 'password': password})

        if user:
            response_data = {
                'id': str(user['_id'])
            }
            return response_data, 201
        else:
            return jsonify({'message': 'Email or password incorrect'}), 401
    else:
        return jsonify({'error': 'Email and password are required'}), 400

# CREATE USER
@routes_user.route('/user/create', methods=['POST'])
def create_user():
    data = request.json
    email = data.get('email')
    username = data.get('username')
    password = data.get('password')

    if not (username and email and password):
        return jsonify({'error': 'Username, email, and password are required'}), 400

    existing_user = db.collection.find_one({'$or': [{'email': email}, {'username': username}]})

    if existing_user is not None:
        return jsonify({'message': 'Username or email already exists'}), 409
    else:
        new_user_data = {
            'username': username,
            'password': password,
            'email': email
        }

        db.collection.insert_one(new_user_data).inserted_id

        response_data = {
            'message': 'User created successfully',
        }
        return jsonify(response_data), 201

# GET USERS
@routes_user.route('/users', methods=['GET'])
def get_users():
    users = []
    for user in db.collection.find():
        users.append({'_id': str(user['_id']), 'username': user['username']})
    return jsonify(users)

# GET USER BY ID
@routes_user.route('/user/<user_id>', methods=['GET'])
def get_user(user_id):
    if ObjectId.is_valid(user_id):
        user = db.collection.find_one({'_id': ObjectId(user_id)})
        if user:
            return jsonify({'_id': str(user['_id']), 'username': user['username']})
    return jsonify({'error': 'User not found'}), 404

# UPDATE USERNAME BY ID
@routes_user.route('/user/username/<user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.json
    username = data.get('username')
    if username :
        updated_user = db.collection.update_one({'_id': ObjectId(user_id)}, {'$set': {'username': username}})
        if updated_user.modified_count:
            return jsonify({'message': 'User updated successfully'})
        else:
            return jsonify({'error': 'Username is the same.'}), 404
    else:
        return jsonify({'error': 'Username and password are required'}), 400

# UPDATE PASSWORD BY ID
@routes_user.route('/user/password/<user_id>', methods=['PUT'])
def update_user_password(user_id):
    data = request.json
    password = data.get('password')
    if password:
        updated_user = db.collection.update_one({'_id': ObjectId(user_id)}, {'$set': {'password': password}})
        if updated_user.modified_count:
            return jsonify({'message': 'Password updated successfully'})
        else:
            return jsonify({'error': 'Password is the same.'}), 404
    else:
        return jsonify({'error': 'Username and password are required'}), 400


