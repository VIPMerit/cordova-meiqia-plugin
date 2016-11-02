package com.hackplan.meiqia;

import org.apache.cordova.*;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.meiqia.core.MQManager;
import com.meiqia.core.callback.OnInitCallback;
import com.meiqia.meiqiasdk.util.MQConfig;
import com.meiqia.meiqiasdk.util.MQIntentBuilder;


public class MeiQia extends CordovaPlugin{

    private static final String LOG_TAG = "MeiQia";
    private Context cordovaContext;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        cordovaContext = cordova.getActivity();
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
                String customId = args.getString(0);
                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        MQIntentBuilder mqb = new MQIntentBuilder(cordovaContext);

                        Intent intent = mqb.build();
                        cordova.getActivity().startActivity(intent);
                    }
                });
            }
            if(action.equals("updateClientInfo")){
                MQManager mqManager = MQManager.getInstance(cordovaContext);
            }
            if(action.equals("closeChat")){}
            if(action.equals("setOffline")){}
        }
        catch (Exception e) {
            Log.e(LOG_TAG,"exception while perfroming action:"+action,e);
            callbackContext.error("exception while performing action"+action);
        }
        return true;
    }
}
