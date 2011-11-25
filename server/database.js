var sys = require("sys"),
    Sequelize = require("sequelize");

var sequelize = new Sequelize('sharelounge', 'sharelounge', 'passwd_sharelounge', {
    host: 'localhost',
    logging: true
});

var User = sequelize.define('User', {
    name: Sequelize.STRING,
    email: Sequelize.STRING,
    password: Sequelize.STRING, // sha1 encrypted
});

var Group = sequelize.define('Group', {
    name: Sequelize.STRING,
    description: Sequelize.TEXT,
    creatorId: Sequelize.INTEGER
});

var JoinedGroup = sequelize.define('JoinedGroup', { // user joins a group
    groupId: Sequelize.INTEGER
});

var Torrent = sequelize.define('Torrent', {
    name: Sequelize.STRING,
    description: Sequelize.TEXT,
    url: Sequelize.STRING,
    creatorId: Sequelize.INTEGER
})

User.hasMany(JoinedGroup);
Group.hasMany(Torrent);

sequelize.sync().on('success', function() {
    console.log('Syncronized tables with database.');
}).on('failure', function(error) {
    console.log('Error synchronizing with database.');
});

exports.users = User;
exports.groups = Group;
exports.joinedGroups = JoinedGroup;
