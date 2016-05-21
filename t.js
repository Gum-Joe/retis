const spawn = require('child_process').spawn;
var which = require('which');
const ls = spawn(which.sync('npm'), ['install', '--color=always']);

ls.stdout.on('data', (data) => {
  console.log(`stdout: ${data}`);
});

ls.stderr.on('data', (data) => {
  console.log(`stderr: ${data}`);
});

ls.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
});
