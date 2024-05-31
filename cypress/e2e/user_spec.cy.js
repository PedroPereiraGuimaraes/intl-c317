describe('User API Tests', () => {
  const apiUrl = 'http://127.0.0.1:5000'
  const userId = '665a1befe267bfeb99fa4d58'
  // Teste de criação de usuário
  it('should create a user that already created', () => {

    cy.request({
      method: 'POST',
      url: `${apiUrl}/user/create`,
      headers: {
        'Content-Type': 'application/json',
      },
      body: {
        email: '123user@example.com',
        username: '12312testuser',
        password: 'testpassword',
        confirmpassword: 'testpassword',
      },
      failOnStatusCode: false, 
    }).then((response) => {
      if (response.status === 409) {
        cy.log('Usuário já existe, ignorando...');
      } else {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('message', 'Usuário criado com sucesso');
      }
    });
    });

  // Teste de login de usuário
  it('should login the user', () => {
    cy.request('POST', `${apiUrl}/user/login`, {
      email: 'user@email.com',
      password: 'user'
    }).then((response) => {
      expect(response.status).to.eq(201);
      expect(response.body).to.have.property('id');
    });
  });

  // Teste de obter todos os usuários
  it('should get all users', () => {
    cy.request('GET', `${apiUrl}/users`).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.an('array');
    });
  });

  // Teste de obter usuário por ID
  it('should get a user by ID', () => {
      cy.request('GET', `${apiUrl}/user/${userId}`).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('username', 'testuser');
      });
  });

  // Teste de atualizar o nome de usuário por ID com o mesmo username
  it('should update username by ID', () => {
    cy.request({ 
    method: 'PUT',
    url: `${apiUrl}/user/username/${userId}`,
    headers: {
      'Content-Type': 'application/json',
    },
    body: {
      username: 'testuser',
    },
    failOnStatusCode: false, 
  }).then((response) => {
        expect(response.status).to.eq(404);
        expect(response.body).to.have.property('error', 'Username is the same.');
      });
  });

  // Teste de atualizar a senha por ID
  it('should update password by ID', () => {
    cy.request({ 
      method: 'PUT',
      url: `${apiUrl}/user/password/${userId}`,
      headers: {
        'Content-Type': 'application/json',
      },
      body: {
        password: 'testpassword123',
      },
      failOnStatusCode: false, 
    }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('message', 'Password updated successfully');
      });
    });

});

