var database = require('./database.js'),
    sys = require('sys');
    
exports._userInformationsResponseFromObject = function(user) {
    return {
        "email": user.email,
        "name": user.name,
        "id": user.id,
        "createdAt": user.createdAt
    }
}

exports._generateResponseString = function(success, message, otherFields) {
    var responseHash =  {
        'success': success,
        'message': message,
    }
    
    for(var attributeName in otherFields) {
        responseHash[attributeName] = otherFields[attributeName];
    }
    
    return JSON.stringify(responseHash);
}
    
exports.verifyCredentials = function(req, res) {
    console.log(sys.inspect(req.params));
    if(!req.param('email') || !req.param('password')) {
        return res.send(exports._generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.users.find({ where: { email: req.param('email'), password: req.param('password') } }).on('success', function(user){
            if(user) {
                return res.send(exports._generateResponseString(true, null, { 'user': exports._userInformationsResponseFromObject(user) }));
            } else {
                return res.send(exports._generateResponseString(false, "Invalid email and/or password.", {}));
            }
        }).on('failure', function(error) {
            return res.send(exports._generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};

exports.createUser = function(req, res) {
    if(!req.param('email') || !req.param('password') || !req.param('name')) {
        return res.send(exports._generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.users.find({ where: { email: req.param('email') } }).on('success', function(user){
            if(user) {
                return res.send(exports._generateResponseString(false, "E-mail already registered.", {}));
            } else {
                database.users.build({ name: req.param('name'), email: req.param('email'), password: req.param('password') }).save().on('success', function(user){
                    return res.send(exports._generateResponseString(true, null, { 'user': exports._userInformationsResponseFromObject(user) }));
                }).on('failure', function(error) {
                    return res.send(exports._generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
                });
            }
        });
    }
};
