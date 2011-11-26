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
        "creatorId": group.creatorId,
        "createdAt": group.createdAt
    }
}

var torrentInformationsResponseFromObject = function(torrent) {
    return {
        "id": torrent.id,
        "name": torrent.name,
        "description": torrent.description,
        "url": torrent.url,
        "groupId": torrent.GroupId,
        "creatorId": torrent.creatorId,
        "createdAt": torrent.createdAt
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
                return res.send(generateResponseString(false, "User not found.", {}));
            } else {
                database.groups.find({ where: { id: req.param('group_id') } }).on('success', function(group){
                    if(!group) {
                        return res.send(generateResponseString(false, "Group not found.", {}));
                    } else {
                        if(group.creatorId == req.user.id) {
                            database.joinedGroups.build({ UserId: user.id, groupId: group.id }).save().on('success', function(joinedGroup){
                                return res.send(generateResponseString(true, null, { 'user': userInformationsResponseFromObject(user), 'group': groupInformationsResponseFromObject(group) }));
                            });
                        } else {
                            return res.send(generateResponseString(false, "You are not the creator of the group.", {}));
                        }
                    }
                });
            }
        });
    }
};

exports.groups = function(req, res) {
    database.users.find({ where: { email: req.param('email') } }).on('success', function(user){
        database.joinedGroups.findAll({ where: { UserId: user.id } }).on('success', function(joinedGroups){            
            if(joinedGroups.length == 0) {
                return res.send(generateResponseString(true, null, { 'groups': [] }));
            } else {
                var groupsIds = new Array();
                for(var i = 0; i < joinedGroups.length; i++) {
                    groupsIds.push(joinedGroups[i].groupId);
                }
            
                database.groups.findAll({ where: { id: groupsIds } }).on('success', function(groups){
                    database.torrents.findAll({ where: { GroupId: groupsIds } }).on('success', function(torrents){
                        database.joinedGroups.findAll({ where: { groupId: groupsIds } }).on('success', function(usersJoinedGroups){
                            var usersIds = new Array();
                            for(var i = 0; i < usersJoinedGroups.length; i++) {
                                usersIds.push(usersJoinedGroups[i].UserId);
                            }
                            
                            database.users.findAll({ where: { id: usersIds } }).on('success', function(users){
                                var chainedGroups = new Array();
                                
                                for(var i = 0; i < groups.length; i++) {
                                    var chainedGroup = groupInformationsResponseFromObject(groups[i]);
                                    var groupUsers = new Array();
                                    var groupTorrents = new Array();
                                    
                                    for(var j = 0; j < users.length; j++) {
                                        var userIsMember = false;
                                        for(var k = 0; k < usersJoinedGroups.length; k++) {
                                            if(usersJoinedGroups[k].UserId == users[j].id && usersJoinedGroups[k].groupId == groups[i].id) {
                                                userIsMember = true;
                                                break;
                                            }
                                        }
                                        if(userIsMember) {
                                            groupUsers.push(userInformationsResponseFromObject(users[j]));
                                        }
                                    }
                                    
                                    for(var j = 0; j < torrents.length; j++) {
                                        if(torrents[j].GroupId == groups[i].id) {
                                            groupTorrents.push(torrentInformationsResponseFromObject(torrents[j]));
                                        }
                                    }
                                    
                                    chainedGroup['users'] = groupUsers;
                                    chainedGroup['torrents'] = groupTorrents;
                                    chainedGroups.push(chainedGroup);
                                }
                                
                                return res.send(generateResponseString(true, null, { 'groups': chainedGroups }));
                            });
                        });
                    });
                });
            }
        })
    }).on('failure', function(error) {
        return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
    });
};

exports.addTorrentToGroup = function(req, res) {
    if(!req.param('group_id') || !req.param('name') || !req.param('url')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.groups.find({ where: { 'id': req.param('group_id') } }).on('success', function(group){
            if(!group) {
                return res.send(generateResponseString(false, "Group not found.", {}));
            } else {
                database.joinedGroups.find({ where: { UserId: req.user.id, groupId: group.id } }).on('success', function(joinedGroup){
                    if(!joinedGroup) {
                        return res.send(generateResponseString(false, "You are not a member of the group.", {}));
                    } else {
                        database.torrents.build({ 
                        GroupId: group.id, 
                        name: req.param('name'), 
                        description: req.param('description'), 
                        url: req.param('url'), 
                        creatorId: req.user.id }).save().on('success', function(torrent){
                            return res.send(generateResponseString(true, null, { 'torrent': torrentInformationsResponseFromObject(torrent) }));
                        });
                    }
                })
            }
        }).on('failure', function(error) {
            return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};

exports.deleteGroup = function(req, res) {
    if(!req.param('group_id')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.groups.find({ where: { id: req.param('group_id') } }).on('success', function(group){
            if(!group) {
                return res.send(generateResponseString(false, "Group not found.", {}));
            } else {
                if(group.creatorId == req.user.id) {
                    group.destroy().on('success', function(){
                        database.joinedGroups.findAll({ where: { 'groupId': group.id } }).on('success', function(joinedUsers){
                            for(var i = 0; i < joinedUsers.length; i++) {
                                joinedUsers[i].destroy(); // deletes user from group (destroyed)
                            }
                            database.torrents.findAll({ where: { 'GroupId': group.id } }).on('success', function(torrents){
                                for(var i = 0; i < torrents.length; i++) {
                                    torrents[i].destroy(); // deletes torrents from group (destroyed)
                                }
                                return res.send(generateResponseString(true, null, {}));
                            });
                        })
                    });
                } else {
                    return res.send(generateResponseString(false, "You are not the creator of the group.", {}));
                }
            }
        }).on('failure', function(error) {
            return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};

exports.deleteUserFromGroup = function(req, res) {
    if(!req.param('group_id') || !(req.param('user_id') || req.param('user_email')) ) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else {
        database.groups.find({ where: { id: req.param('group_id') } }).on('success', function(group){
            if(!group) {
                return res.send(generateResponseString(false, "Group not found.", {}));
            } else {
                if(group.creatorId == req.user.id) {
                    var userQuery;
                    if(req.param('user_id')) {
                        userQuery = { 'id': req.param('user_id') }
                    } else if(req.param('user_email')) {
                        userQuery = { 'email': req.param('user_email') }
                    }
                    database.users.find({ where: userQuery }).on('success', function(user){
                        if(!user) {
                            return res.send(generateResponseString(false, "User not found.", {}));
                        } else {
                            database.joinedGroups.find({ where: { 'UserId': user.id, 'groupId': group.id } }).on('success', function(joinedGroup){
                                joinedGroup.destroy().on('success', function(){
                                    return res.send(generateResponseString(true, null, {}));
                                });
                            });
                        }
                    });
                } else {
                    return res.send(generateResponseString(false, "You are not the creator of the group.", {}));
                }
            }
        }).on('failure', function(error) {
            return res.send(generateResponseString(false, "Internal error (" + error.toString() + ").", {}));
        });
    }
};

exports.deleteTorrentFromGroup = function(req, res) {
    if(!req.param('group_id') || !req.param('torrent_id')) {
        return res.send(generateResponseString(false, "Missing parameters.", {}));
    } else{
        database.groups.find({ where: { id: req.param('group_id') } }).on('success', function(group){
            if(!group) {
                return res.send(generateResponseString(false, "Group not found.", {}));
            } else {
                database.joinedGroups.find({ where: { UserId: req.user.id, groupId: group.id } }).on('success', function(joinedGroup){
                    if(!joinedGroup) {
                        return res.send(generateResponseString(false, "You are not a member of the group.", {}));
                    } else {
                        database.torrents.find({ where: { id: req.param('torrent_id') } }).on('success', function(torrent){
                            if(!torrent) {
                                return res.send(generateResponseString(false, "Torrent not found.", {}));
                            } else {
                                if(torrent.creatorId == req.user.id || group.creatorId == req.user.id) {
                                    torrent.destroy().on('success', function(){
                                        return res.send(generateResponseString(true, null, {}));
                                    });
                                } else {
                                    return res.send(generateResponseString(false, "You are not the creator of that torrent.", {}));
                                }
                            }
                        });
                    }
                });
            }
        });
    }
};
