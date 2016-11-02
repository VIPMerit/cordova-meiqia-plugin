var MeiQia = function(){};

MeiQia.prototype.init = function(completionCallback){
  cordova.exec(completionCallback, failureCallback, "MeiQia", "init", []);
};

module.exports = new MeiQia();
