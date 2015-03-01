package com.hackplan.meiqia;

import com.mechat.mechatlibrary.MCClient;
import com.mechat.mechatlibrary.callback.OnInitCallback;
import com.mechat.mechatlibrary.utils.Utils;

import android.app.Application;
import android.widget.Toast;

public class MyApplication extends Application {
    @Override
    public void onCreate() {
        // TODO Auto-generated method stub
        super.onCreate();

        // appKey获取途径：请使用美洽管理员帐号登录美洽，在入口设置菜单,inApp SDK中查看

        /**
         * 测试appKey ： 543f883c3baac91456000001
         * 
         * 账号：demo+sdk@meiqia.com 密码：123456
         * 
         * 通过 https://meiqia.com/login 登陆，登陆后重新进入demo，即可分配到该客服。
         */

        // 初始化美洽SDK
        MCClient.init(this, "543f883c3baac91456000001", new OnInitCallback() {

            @Override
            public void onSuccess(String response) {
                // TODO Auto-generated method stub
                // Success
            }

            @Override
            public void onFailed(String response) {
                // TODO Auto-generated method stub
                // Failed
            }
        });
    }
}