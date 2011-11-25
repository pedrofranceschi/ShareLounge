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
app.post('/api/delete_group', api.verifyCredentialsFilter, api.deleteGroup);
app.post('/api/add_user_to_group', api.verifyCredentialsFilter, api.addUserToGroup);
app.post('/api/delete_user_from_group', api.verifyCredentialsFilter, api.deleteUserFromGroup);

app.post('/api/groups', api.verifyCredentialsFilter, api.groups); // downloads everything (there will be a socket for small updates)
app.post('/api/add_torrent_to_group', api.verifyCredentialsFilter, api.addTorrentToGroup); // delete method

app.listen(3000);
console.log("Server on port %s", app.address().port);