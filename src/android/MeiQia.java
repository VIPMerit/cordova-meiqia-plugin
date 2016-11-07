package com.vipmerit.meiqia;

import org.apache.cordova.*;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.meiqia.core.MQManager;
import com.meiqia.core.callback.OnClientInfoCallback;
import com.meiqia.core.callback.OnInitCallback;
import com.meiqia.meiqiasdk.util.MQConfig;
import com.meiqia.meiqiasdk.util.MQIntentBuilder;

import java.util.HashMap;
import java.util.Iterator;


public class MeiQia extends CordovaPlugin{

    private static final String LOG_TAG = "MeiQia";
    private Context cordovaContext;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        cordovaContext = cordova.getActivity();
    }

    private HashMap<String, String> buildClientInfo(JSONObject raw) {
        HashMap<String, String> clientInfo = new HashMap<String, String>();

        Iterator<String> iter = raw.keys();
        while (iter.hasNext()) {
            String key = iter.next();
            try {
                clientInfo.put(key, raw.getString(key));
            } catch (JSONException e) {
                // Something went wrong!
            }
        }
        return clientInfo;
    }

    @Override
    public boolean execute(String action, JSONArray args,final CallbackContext callbackContext) throws JSONException {
        try {
            Log.e(LOG_TAG, "called action:"+action);
            if(action.equals("init")) {
                String appKey = args.getString(0);
                MQConfig.init(cordovaContext, appKey, new OnInitCallback() {
                    @Override
                    public void onSuccess(String clientId) {
                        callbackContext.success();
                    }

                    @Override
                    public void onFailure(int code, String message) {
                        callbackContext.error(LOG_TAG + ", " + code +", " +message);
                    }
                });
            }
            if(action.equals("openChat")){
                JSONObject initArgs = new JSONObject(args.getString(0));
                final String customId = initArgs.getString("haishangId");
                final HashMap<String,String> clientInfo = buildClientInfo(initArgs);
                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        MQIntentBuilder mqb = new MQIntentBuilder(cordovaContext);
                        mqb.setCustomizedId(customId);
                        mqb.setClientInfo(clientInfo);
                        Intent intent = mqb.build();
                        cordova.getActivity().startActivity(intent);
                        callbackContext.success();
                    }
                });
            }
            if(action.equals("updateClientInfo")){
                MQManager mqManager = MQManager.getInstance(cordovaContext);
                JSONObject initArgs = new JSONObject(args.getString(0));
                HashMap<String,String> clientInfo = buildClientInfo(initArgs);
                mqManager.updateClientInfo(clientInfo, new OnClientInfoCallback(){
                    @Override
                    public void onSuccess() {
                        callbackContext.success();
                    }

                    @Override
                    public void onFailure(int code, String message) {
                        callbackContext.error(LOG_TAG + ", " + code +", " +message);
                    }
                });
            }
            if(action.equals("closeChat")){
                MQManager mqManager = MQManager.getInstance(cordovaContext);
                mqManager.closeMeiqiaService();
                callbackContext.success();
            }
            if(action.equals("setOffline")){
                MQManager mqManager = MQManager.getInstance(cordovaContext);
                mqManager.setClientOffline();
                callbackContext.success();
            }
        }
        catch (Exception e) {
            Log.e(LOG_TAG,"exception while performing action:"+action,e);
            callbackContext.error("exception while performing action"+action);
        }
        return true;
    }
}
