#!/usr/bin/env node

const program = require('commander');
const chalk = require('chalk');
const { spawnSync } = require('child_process');
const { join, resolve } = require('path');
const packageInfo = require('../package.json');
const os = require('os');
const fs = require('fs');
const temp = require('temp');

program
  .version(packageInfo.version)
  .usage('[filename|url]')
  .description('Start a kraken app.')
  .option('-b --bundle <bundle>', 'Bundle path. One of bundle or url is needed, if both determined, bundlePath will be used.')
  .option('-u --url <url>', 'Bundle url. One of bundle or url is needed, if both determined, bundlePath will be used.')
  .option('-i --instruct <instruct>', 'instruct file path.')
  .option('-s, --source <source>', 'Source code. pass source directory from command line')
  .option('-m --runtime-mode <runtimeMode>', 'Runtime mode, debug | release.', 'debug')
  .option('--enable-kraken-js-log', 'print kraken js to dart log', false)
  .option('--show-performance-monitor', 'show render performance monitor', false)
  .option('-d, --debug-layout', 'debug element\'s paint layout', false)
  .action((options) => {
    let { bundle, url, source, instruct } = options;

    if (!bundle && !url && !source && !options.args) {
      program.help();
    } else {
      const firstArgs = options.args[0];

      if (firstArgs) {
        if (/^http/.test(firstArgs)) {
          url = firstArgs;
        } else {
          bundle = firstArgs;
        }
      }

      const env = Object.assign({}, process.env);
      const shellPath = getShellPath(options.runtimeMode);
      env['KRAKEN_LIBRARY_PATH'] = resolve(__dirname, '../build/lib');

      if (options.enableKrakenJsLog) {
        env['ENABLE_KRAKEN_JS_LOG'] = 'true';
      }

      if (options.showPerformanceMonitor) {
        env['KRAKEN_ENABLE_PERFORMANCE_OVERLAY'] = true;
      }

      if (options.debugLayout) {
        env['KRAKEN_ENABLE_DEBUG'] = true;
      }

      if (instruct) {
        const absoluteInstructPath = resolve(process.cwd(), instruct);
        env['KRAKEN_INSTRUCT_PATH'] = absoluteInstructPath;
      }

      if (bundle) {
        const absoluteBundlePath = resolve(process.cwd(), bundle);
        env['KRAKEN_BUNDLE_PATH'] = absoluteBundlePath;
      } else if (url) {
        env['KRAKEN_BUNDLE_URL'] = url;
      } else if (source) {
        let t = temp.track();
        let tempdir = t.openSync('source');
        let tempPath = tempdir.path;
        fs.writeFileSync(tempPath, source, { encoding: 'utf-8' });
        env['KRAKEN_BUNDLE_PATH'] = tempPath;
      }

      console.log(chalk.green('Execute binary:'), shellPath, '\n');
      spawnSync(shellPath, [], {
        stdio: 'inherit',
        env,
      });
    }
  });

program.parse(process.argv);

function getShellPath(runtimeMode) {
  const appPath = join(__dirname, '../build/app');
  const platform = os.platform();
  if (platform === 'darwin') {
    if (runtimeMode === 'release') {
      return join(appPath, 'release/Kraken.app/Contents/MacOS/Kraken');
    } else {
      return join(appPath, 'debug/Kraken.app/Contents/MacOS/Kraken');
    }
  } else if (platform === 'linux') {
    return join(appPath, 'kraken');
  } else {
    console.log(chalk.red('[ERROR]: Something is failed. please contact @chenghuai.dtc'));
    process.exit(1);
  }
}
