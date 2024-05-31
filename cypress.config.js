const { defineConfig } = require("cypress");
const path = require("path");

module.exports = defineConfig({
  reporter: 'cypress-mochawesome-reporter',
  reporterOptions: {
    reportDir: 'cypress/reports/html', // Define o diretório para os relatórios
    configFile: path.resolve(__dirname, "cypress-configs/reporter-config.json"),
    html: true,
  },
  e2e: {
    setupNodeEvents(on, config) {
      require('cypress-mochawesome-reporter/plugin')(on);
      // implemente os event listeners do Node aqui
    },
    video: true,
    screenshotOnRunFailure: true,
    screenshotOnPass: true,
    screenshotsFolder: "cypress/reports/html/screenshots", // Define o diretório para capturas de tela
    videosFolder: "cypress/reports/html/videos", // Define o diretório para vídeos
  },
});