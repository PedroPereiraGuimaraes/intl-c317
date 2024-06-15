let apiUrl = 'http://127.0.0.1:5000'
let userId = '666cc65067cff68d6eafc60e'

describe('User API Tests', () => {

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
        expect(response.status).to.eq(201);
        expect(response.body).to.have.property('message', 'User created successfully');
      }
    });
    });

  // Teste de login de usuário
  it('should login the user', () => {
    cy.request('POST', `${apiUrl}/user/login`, {
      email: 'user@email.com',
      password: 'user'
    }).then((response) => {
      expect(response.status).to.eq(200);
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
        expect(response.body).to.have.property('username', 'user');
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
      username: 'user',
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

  // Teste de atualizar a senha por ID
  it('should update password by ID', () => {
    cy.request({ 
      method: 'PUT',
      url: `${apiUrl}/user/password/${userId}`,
      headers: {
        'Content-Type': 'application/json',
      },
      body: {
        password: 'user',
      },
      failOnStatusCode: false, 
    }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('message', 'Password updated successfully');
      });
    });


});

describe('Conversation API Tests',()=>{
  let chatId;

  it('User create chat', () => {
    cy.request({ 
      method: 'POST',
        url: `${apiUrl}/chat/create`,
          headers: {
            'Content-Type': 'application/json',
          },
          body: {
            'userId': userId          
          },
          failOnStatusCode: false, 
    }).then((response) => {
        expect(response.status).to.eq(201);
        chatId = response.body[0].chatId;
        expect(response.body).to.be.an('array');
      });
  });

  // Teste de conversas
  it('Exchange messages with AI', () => {
    cy.request({ 
      method: 'POST',
        url: `${apiUrl}/chat/sendquestion`,
          headers: {
            'Content-Type': 'application/json',
          },
          body: {
            message: 'Qual o nome da empresa?',
            userId: userId,
            chatId: chatId,            
          },
          failOnStatusCode: false, 
    }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('response', 'IWS atendimentos');
      });
  });


    it('All messages from a chat', () => {
      cy.request({ 
        method: 'GET',
          url: `${apiUrl}/chats/user/messages/${chatId}`,
      }).then((response) => {
          expect(response.status).to.eq(200);
          expect(response.body).to.be.an('array');
        });
    });

      
    it('All messages from a chat', () => {
      cy.request({ 
        method: 'GET',
          url: `${apiUrl}/chats/user/messages/${chatId}`,
      }).then((response) => {
          expect(response.status).to.eq(200);
          expect(response.body).to.be.an('array');
        });
    });

      
    it('Search a chat with userId', () => {
      cy.request({ 
        method: 'GET',
          url: `${apiUrl}/chats/user/${userId}`,
      }).then((response) => {
          expect(response.status).to.eq(200);
          expect(response.body).to.be.an('array');
        });
    });


});