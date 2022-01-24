const chalk = require('chalk');

const msg = `
Welcome to the ${chalk.blue.bold('Ionic')} ${chalk.green.bold('AppBrahma')}${chalk.red.bold('Unimobile')} Starter!

For more details, go ${chalk.bold('https://www.brillium.tech/appbrahma/unimobile/starter')}
`.trim();

console.log(msg);
console.log(JSON.stringify(msg));
