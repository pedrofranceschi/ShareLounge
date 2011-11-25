var express = require('express'),
    sys = require('sys'),
    api = require('./api.js');
    
var app = express.createServer();

app.use(express.bodyParser());

app.get('/', function(req, res){
    res.send('Hello World');
});

app.post('/api/verify_credentials', api.verifyCredentials);
app.post('/api/create_user', api.createUser);
app.post('/api/create_group', api.verifyCredentialsFilter, api.createGroup);

app.listen(3000);
console.log("Server on port %s", app.address().port);