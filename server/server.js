var express = require('express'),
    sys = require('sys');
    
var app = express.createServer();

app.get('/', function(req, res){
    res.send('Hello World');
});

app.listen(3000);
console.log("Server on port %s", app.address().port);