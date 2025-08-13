const https = require('https');
https.get('https://copilot-proxy.githubusercontent.com/v1/engines/copilot-codex', (res) => {
  console.log('statusCode:', res.statusCode);
}).on('error', (e) => {
  console.error(e);
});

