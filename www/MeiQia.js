var MeiQia = function(){};

MeiQia.prototype.meiQia = function(success, failure, number){
    cordova.exec(success, failure, "MeiQia", "meiQia", [number]);
};

//Plug in to Cordova
cordova.addConstructor(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };

    if(!window.plugins) window.plugins = {};
    window.plugins.MeiQia = new MeiQia();
});
