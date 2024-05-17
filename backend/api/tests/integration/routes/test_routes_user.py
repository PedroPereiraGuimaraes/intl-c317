from unittest.mock import patch
import pytest
from requests import Session

URL = "http://localhost:5000/"

EMAIL = "inajahacosta@teste.com"
PASSWORD = "123456789@"
USERNAME = "InajahaCosta"
USER_ID= "66328a656db2b9babe27dd13"


@pytest.fixture()
def session():
    session = Session()
    yield session
    session.close()

def test_create_user_success(session):
    """
    Test creating a new user with valid data.
    """
    data = {
        "email": EMAIL,
        "username": USERNAME,
        "password": PASSWORD
    }

    response = session.post(URL + "/user/create", json=data)

    assert response.status_code == 201

    response_data = response.json()
    assert isinstance(response_data, dict)
    assert "message" in response_data
    assert response_data["message"] == "User created successfully"

def test_create_user_missing_fields(session):
    """
    Test creating a user with missing required fields.
    """
    data = {"email": EMAIL, "password": PASSWORD}
    response = session.post(URL + "/user/create", json=data)

    assert response.status_code == 400

    response_data = response.json()
    assert isinstance(response_data, dict)
    assert "error" in response_data
    assert response_data["error"] == "Username, email, and password are required"

    data = {"username": USERNAME, "password": PASSWORD}
    response = session.post(URL + "/user/create", json=data)


def test_successful_login(session):
    data = {"email": "inajahacostav@gmail.com", "password": "123456789@"}
    response = session.post(URL + "/user/login", json=data)

    print(response)

    assert response.status_code == 201

    response_data = response.json()
    assert isinstance(response_data, dict)
    assert "id" in response_data


def test_invalid_credentials(session):
    data = {"email": "test_user@example.com", "password": "invalid_password"}
    response = session.post(URL + "/user/login", json=data)

    assert response.status_code == 401

    response_data = response.json()
    assert isinstance(response_data, dict)
    assert "message" in response_data
    assert response_data["message"] == 'Email or password incorrect'

def test_get_user_success(session):
    """
    Test retrieving a user with a valid ID and verify the response data.
    """
    EXPECTED_USER_DATA = {
    "_id": USER_ID,
    "username": "InajahaCosta"
    }
      
    response = session.get(URL + f"/user/{USER_ID}")

    assert response.status_code == 200

    response_data = response.json()
    assert isinstance(response_data, dict)
    assert response_data == EXPECTED_USER_DATA

def test_get_user_invalid_id(session):
    """
    Test retrieving a user with an invalid ID format.
    """
    INVALID_USER_ID = "66328a656db2b9babe27dd1"

    response = session.get(URL + f"/user/{INVALID_USER_ID}")

    assert response.status_code == 404

    # Validate response data format (may vary depending on implementation)
    response_data = response.json()
    assert isinstance(response_data, dict)
    assert "error" in response_data
    assert response_data["error"] == "User not found"