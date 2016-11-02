var MeiQia = function(){};

MeiQia.prototype.init = function(completionCallback, failureCallback){
  cordova.exec(completionCallback, failureCallback, "MeiQia", "init", []);
};

module.exports = new MeiQia();
