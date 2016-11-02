var MeiQia = {};

MeiQia.init = function(success, failure, appKey){
    cordova.exec(success, failure, "MeiQia", "init", [appKey]);
};

MeiQia.showConversations = function(success, failure, customId, clientInfo ){
    cordova.exec(success, failure, "MeiQia", "init", [ customId, clientInfo ]);
};

MeiQia.updateUserProperties = function(success, failure,  clientInfo ){
    cordova.exec(success, failure, "MeiQia", "updateClientInfo", [ clientInfo ]);
};

MeiQia.closeChat = function(success, failure){
    cordova.exec(success, failure, "MeiQia", "closeChat", [ ]);
};

MeiQia.setOffline = function(success, failure ){
    cordova.exec(success, failure, "MeiQia", "setOffline", [ ]);
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