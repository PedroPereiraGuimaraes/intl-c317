describe('User API Tests', () => {
  const apiUrl = 

  // Teste de criação de usuário
  it('should create a new user', () => {
    cy.request('POST', `${apiUrl}/user/create`, {
      email: 'testuser@example.com',
      username: 'testuser',
      password: 'testpassword'
    }).then((response) => {
      expect(response.status).to.eq(201);
      expect(response.body).to.have.property('message', 'User created successfully');
    });
  });

  // Teste de login de usuário
  it('should login the user', () => {
    cy.request('POST', `${apiUrl}/user/login`, {
      email: 'testuser@example.com',
      password: 'testpassword'
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
    cy.request('POST', `${apiUrl}/user/create`, {
      email: 'testuser2@example.com',
      username: 'testuser2',
      password: 'testpassword'
    }).then((createResponse) => {
      const userId = createResponse.body.id;

      cy.request('GET', `${apiUrl}/user/${userId}`).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('username', 'testuser2');
      });
    });
  });

  // Teste de atualizar o nome de usuário por ID
  it('should update username by ID', () => {
    cy.request('POST', `${apiUrl}/user/create`, {
      email: 'testuser3@example.com',
      username: 'testuser3',
      password: 'testpassword'
    }).then((createResponse) => {
      const userId = createResponse.body.id;

      cy.request('PUT', `${apiUrl}/user/username/${userId}`, {
        username: 'updateduser3'
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('message', 'User updated successfully');
      });
    });
  });

  // Teste de atualizar a senha por ID
  it('should update password by ID', () => {
    cy.request('POST', `${apiUrl}/user/create`, {
      email: 'testuser4@example.com',
      username: 'testuser4',
      password: 'testpassword'
    }).then((createResponse) => {
      const userId = createResponse.body.id;

      cy.request('PUT', `${apiUrl}/user/password/${userId}`, {
        password: 'newpassword'
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('message', 'Password updated successfully');
      });
    });
  });
});
