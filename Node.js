const https = require('https');
 
const fs = require('fs');
 
const options = {
 
key: fs.readFileSync('key.pem'),
 
cert: fs.readFileSync('cert.pem')
 
};
 
https.createServer(options, (req, res) =&amp;amp;gt; {
 
res.writeHead(200);
 
res.end('Secure connection established');
 
}).listen(8080, '127.0.0.1', () =&amp;amp;gt; {
 
console.log('Server running at https://localhost:8080/');
 
});
