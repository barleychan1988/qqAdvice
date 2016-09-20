
var exec = require('cordova/exec');

exports.openQQ = function(success, error, qq)
{
    exec(success, error, "QQAdvice", "openQQ", [qq]);
};
