const advancedLabels = [
  'Max Calories per Slice',
  'Excluded tools',
  'Must be vegetarian',
  'Custom Pizza Name',
]

function timestamp() {
  const digits = (number) => String(number).padStart(2, '0')
  const now = new Date()
  const date = [now.getFullYear(), now.getMonth() + 1, now.getDate()].map(digits).join('')
  const time = [now.getHours(), now.getMinutes(), now.getSeconds()].map(digits).join('')
  return date + '-' + time
}

describe('QP-01 A custom pizza reaches the admin list', () => {
  // Verify the restricted recommendation, guest login requirement and matching admin entry.
  it('follows all seven steps in the same browser session', () => {
    const name = 'Lab Pizza ' + timestamp()
    const limit = 600
    const excludedTool = 'Knife'

    // Step 1: Verify the home page heading.
    cy.visit('/')
    cy.get('h1').should('have.text', 'Looking to break out of your pizza routine?')
    cy.get('#svelte-announcer').should('exist')

    // Step 2: Show and verify the advanced fields.
    cy.contains('label', 'Advanced').click()
    advancedLabels.forEach((label) => cy.contains('label', label).should('be.visible'))
    cy.contains('option', /^Knife$/).should('exist')

    // Step 3: Fill the fields and verify their values.
    cy.contains('label', 'Max Calories per Slice').siblings('input').clear()
    cy.contains('label', 'Max Calories per Slice').siblings('input')
      .type(String(limit)).should('have.value', String(limit))
    cy.get('select').select(excludedTool)
    cy.contains('option', /^Knife$/).should('be.selected')
    cy.get('#default-checkbox').check().should('be.checked')
    cy.get('input#pizza-name').type(name).should('have.value', name)

    // Step 4: Check the request, the server response and the visible recommendation.
    cy.intercept('POST', '/api/pizza').as('pizza')
    cy.get('button[name="pizza-please"]').click()
    cy.wait('@pizza').then(({ request, response }) => {
      expect(request.body.maxCaloriesPerSlice).to.equal(limit)
      expect(response.statusCode).to.equal(200)
      const { pizza, calories } = response.body
      expect(pizza.tool).to.be.a('string').and.not.equal(excludedTool)
      expect(calories).to.be.at.most(limit)
      cy.get('#recommendations').should('contain.text', 'Name: ' + name)
      cy.contains('#recommendations p', 'Tool:').should('have.text', 'Tool: ' + pizza.tool)
      cy.contains('#recommendations p', 'Calories per slice:')
        .should('have.text', 'Calories per slice: ' + calories)
      cy.wrap(pizza.tool).as('tool')
      cy.task('record', name + ' | ' + pizza.tool + ' | ' + calories + ' calories per slice')
    })
    cy.screenshot('qp01-step4-recommendation')

    // Step 5: Verify that a guest cannot rate the pizza.
    cy.get('button[name="rate-5"]').click()
    cy.get('#rate-result').should('have.text', 'Please log in first.')
    cy.screenshot('qp01-step5-login-needed')

    // Step 6: Sign in and wait for the recommendation list.
    cy.adminLogin()
    cy.contains('Latest pizza recommendations').should('be.visible')

    // Step 7: Match the generated pizza and the tool seen in step 4.
    cy.get('@tool').then((tool) => {
      cy.contains('li', name).should('contain.text', '(tool=' + tool + ',')
        .invoke('text').then((line) => cy.task('record', line.trim()))
    })
    cy.screenshot('qp01-step7-admin-list')
  })
})
