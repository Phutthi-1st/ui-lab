Cypress.Commands.add('adminLogin', () => {
  cy.visit('/admin')
  cy.get('#svelte-announcer').should('exist')
  cy.get('#username').clear().type('admin')
  cy.get('#password').clear().type('admin', { log: false })
  cy.get('button[type="submit"]').click()
})
