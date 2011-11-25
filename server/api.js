var database = require('./database.js'),
    sys = require('sys');
    
// Response helpers

var userInformationsResponseFromObject = function(user) {
    return {
        "id": user.id,
        "email": user.email,
        "name": user.name,
        "createdAt": user.createdAt
    }
}

var groupInformationsResponseFromObject = function(group) {
    return {
        "id": group.id,
        "name": group.name,
        "description": group.description,
        "creatorId": group.creatorId
    }
}

var generateResponseString = function(success, message, otherFields) {
    var responseHash =  {
        'success': success,
        'message': message,
    }
    
    for(var attributeName in otherFields) {
        responseHash[attributeName] = otherFields[attributeName];
    }
    
    return JSON.stringify(responseHash);
}

// API filters

exports.verifyCredentialsFilter = function (req, res, next) {    
    if(!req.param('email') || !req.param('password')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.users.find({ where: { email: req.param('email'), password: req.param('password') } }).on('success', function(user){
            if(user) {
                req['user'] = user;
                next();
            } else {
                return res.send(generateResponseString(false, "Invalid email and/or password.", {}));
            }
        });
    }
};

// API methods
    
exports.verifyCredentials = function(req, res) {
    console.log(sys.inspect(req.params));
    if(!req.param('email') || !req.param('password')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.users.find({ where: { email: req.param('email'), password: req.param('password') } }).on('success', function(user){
            if(user) {
                return res.send(generateResponseString(true, null, { 'user': userInformationsResponseFromObject(user) }));
            } else {
                return res.send(generateResponseString(false, "Invalid email and/or password.", {}));
            }
        }).on('failure', function(error) {
            return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};

exports.createUser = function(req, res) {
    if(!req.param('email') || !req.param('password') || !req.param('name')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.users.find({ where: { email: req.param('email') } }).on('success', function(user){
            if(user) {
                return res.send(generateResponseString(false, "E-mail already registered.", {}));
            } else {
                database.users.build({ name: req.param('name'), email: req.param('email'), password: req.param('password') }).save().on('success', function(user){
                    return res.send(generateResponseString(true, null, { 'user': userInformationsResponseFromObject(user) }));
                }).on('failure', function(error) {
                    return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
                });
            }
        });
    }
};

exports.createGroup = function(req, res) {
    if(!req.param('name')) { // email and password are already handled in filter
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.groups.build({ name: req.param('name'), description: req.param('description'), creatorId: req.user.id }).save().on('success', function(group){
            return res.send(generateResponseString(true, null, { 'group': groupInformationsResponseFromObject(group) }));
        }).on('failure', function(error) {
            return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};
