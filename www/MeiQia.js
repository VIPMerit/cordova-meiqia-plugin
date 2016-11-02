var MeiQia = function(){};

MeiQia.prototype.init = function(completionCallback, failureCallback){
  cordova.exec(completionCallback, failureCallback, "MeiQia", "init", []);
};

MeiQia.prototype.version = function(completionCallback, failureCallback){
  cordova.exec(completionCallback, failureCallback, "MeiQia", "version", []);
};


MeiQia.prototype.openChat = function(completionCallback, failureCallback){
  cordova.exec(completionCallback, failureCallback, "MeiQia", "openChat", []);
};

module.exports = new MeiQia();
