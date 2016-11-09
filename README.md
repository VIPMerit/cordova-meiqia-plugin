install
```
ionic plugin add https://github.com/codefrwd/cordova-meiqia-plugin--save
```

functions
```
window.plugins.MeiQia.init('your-app-key', callback);
window.plugins.MeiQia.showConversations('internal id', {some: "detals"}, callback);
window.plugins.MeiQia.updateClientInfo({some: "detals"}, callback);
window.plugins.MeiQia.closeChat(callback);
window.plugins.MeiQia.setOffline(callback);
```

callback is optional, will fallback to console.log

demo callback
```
var callback = functions(error, value){
  if(error){
    console.log("it failed here is why", error);
  }else{
    console.log("this is the value returned", value);
  }
}
```

client info struct
``` 
haishangId: "84892eaa-2f60-47fb-b109-463fecbe1e7e",
name: "someName",
spreeId: "100",
phone: "123456789"
```

with `haishangId` mandatory 