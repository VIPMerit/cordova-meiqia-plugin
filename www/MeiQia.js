var MeiQia = {};

var buildSuccess = function(callback){
    callback = callbackOrNoop(callback);
    return function(result){
        callback(null, result);
    }
}

var buildFailure = function(callback){
    callback = callbackOrNoop(callback);
    return function(error){
        callback(error);
    }
}

var callbackOrNoop = function(callback){
    return callback ? callback : function(err, val) { console.log(err, val); }
}

MeiQia.init = function(appKey, callback){
    var success = buildSuccess(callback);
    var failure = buildFailure(callback);

    cordova.exec(success, failure, "MeiQia", "init", [appKey]);
};

MeiQia.showConversations = function(clientInfo, callback){
    var success = buildSuccess(callback);
    var failure = buildFailure(callback);
    console.log(clientInfo);
    cordova.exec(success, failure, "MeiQia", "openChat", [clientInfo]);
};

MeiQia.updateClientInfo = function(clientInfo, callback){
    var success = buildSuccess(callback);
    var failure = buildFailure(callback);
    cordova.exec(success, failure, "MeiQia", "updateClientInfo", [clientInfo]);
};

MeiQia.closeChat = function(callback){
    var success = buildSuccess(callback);
    var failure = buildFailure(callback);
    cordova.exec(success, failure, "MeiQia", "closeChat", [ ]);
};

MeiQia.setOffline = function(haishangId, callback){
    var success = buildSuccess(callback);
    var failure = buildFailure(callback);
    cordova.exec(success, failure, "MeiQia", "setOffline", [haishangId]);
};

//Plug in to Cordova
cordova.addConstructor(function() {
    if (!window.Cordova) {
        window.Cordova = cordova;
    };

    if(!window.plugins) window.plugins = {};
    window.plugins.MeiQia = MeiQia
});

module.exports = MeiQia;
