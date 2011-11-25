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
    if(!req.param('name')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.groups.build({ name: req.param('name'), description: req.param('description'), creatorId: req.user.id }).save().on('success', function(group){
            database.joinedGroups.build({ UserId: req.user.id, groupId: group.id }).save().on('success', function(joinedGroup){
                return res.send(generateResponseString(true, null, { 'group': groupInformationsResponseFromObject(group) }));
            });
        }).on('failure', function(error) {
            return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};


exports.addUserToGroup = function(req, res) {
    if(!req.param('group_id') || !req.param('user_email')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.users.find({ where: { email: req.param('user_email') } }).on('success', function(user){
            if(!user) {
                return res.send(generateResponseString(false, "No user found with that e-mail.", {}));
            } else {
                database.groups.find({ where: { id: req.param('group_id') } }).on('success', function(group){
                    if(!group) {
                        return res.send(generateResponseString(false, "No group found with that id.", {}));
                    } else {
                        if(group.creatorId == req.user.id) {
                            database.joinedGroups.build({ UserId: user.id, groupId: group.id }).save().on('success', function(joinedGroup){
                                return res.send(generateResponseString(true, null, { 'user': userInformationsResponseFromObject(user), 'group': groupInformationsResponseFromObject(group) }));
                            });
                        } else {
                            return res.send(generateResponseString(false, "You are not the creator of that group.", {}));
                        }
                    }
                });
            }
        });
    }
};