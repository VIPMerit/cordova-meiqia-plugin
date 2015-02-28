package com.hackplan.meiqia;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;


import java.util.HashMap;
import java.util.Map;
import com.mechat.mechatlibrary.MCClient;
import com.mechat.mechatlibrary.MCOnlineConfig;
import com.mechat.mechatlibrary.MCUserConfig;

public class MeiQia extends CordovaPlugin
{
  @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        String number = args.getString(0);

        try {
            // TODO Auto-generated method stub
            // 设置用户上线参数
            MCOnlineConfig onlineConfig = new MCOnlineConfig();
            onlineConfig.setChannel("channel"); // 设置渠道

            // onlineConfig.setSpecifyAgent("4840", false); // 设置指定客服
            // onlineConfig.setSpecifyGroup("1"); // 设置指定分组

            // 更新用户信息，可选. 
            // 详细信息可以到文档中查看：https://meiqia.com/docs/sdk/android.html
            MCUserConfig mcUserConfig = new MCUserConfig();
            Map<String,String> userInfo = new HashMap<String,String>();
            userInfo.put(MCUserConfig.PersonalInfo.REAL_NAME,"real_name" );
            userInfo.put(MCUserConfig.Contact.TEL,"130000000");
            Map<String,String> userInfoExtra = new HashMap<String,String>();
            userInfoExtra.put("extra_key","extra_value");
            userInfoExtra.put("gold","10000");
            mcUserConfig.setUserInfo(this.cordova.getActivity().getApplicationContext(), userInfo,userInfoExtra, null);
            
            // 启动客服对话界面
            MCClient.getInstance().startMCConversationActivity(onlineConfig);
        }
        catch (Exception e) {
            callbackContext.error(e.getMessage());
        }
        return true;
    }
}
