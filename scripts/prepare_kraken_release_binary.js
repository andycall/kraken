require('./tasks');
const chalk = require('chalk');
const { series } = require('gulp');

series(
  'sdk-clean',
  'compile-polyfill',
  'build-darwin-kraken-lib-release',
  'build-ios-kraken-lib-release',
  'build-android-kraken-lib-release',
)((err) => {
  if (err) {
    console.log(err);
  } else {
    console.log(chalk.green('Success.'));
  }
});