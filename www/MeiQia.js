var MeiQia = function(){};


// cordova.exec(success,failure,"MeiQia",functionName,argumentsArray);   

MeiQia.prototype.init = function(success, failure, appKey){
    cordova.exec(success, failure, "MeiQia", "init", [appKey]);
};

MeiQia.prototype.openChat = function(success, failure){
    cordova.exec(success, failure, "MeiQia", "openChat",[]);
};

//Plug in to Cordova
cordova.addConstructor(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };

    if(!window.plugins) window.plugins = {};
    window.plugins.MeiQia = new MeiQia();
});
