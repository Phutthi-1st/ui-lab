const { defineConfig } = require('cypress')

module.exports = defineConfig({
  viewportWidth: 1280,
  viewportHeight: 1600,
  defaultCommandTimeout: 15000,
  video: true,
  allowCypressEnv: false,
  e2e: {
    setupNodeEvents(on) {
      on('task', {
        record(message) {
          console.log(message)
          return null
        },
      })
    },
    baseUrl: 'https://quickpizza.grafana.com',
  },
})
