//
//  MCDefination.h
//  MeChatSDK
//
//  Created by Injoy on 14-8-4.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 消息类型枚举
 */
typedef enum{
    //文字
    MessageType_Text          = 0,
    //图片
    MessageType_Image,
    //声音
    MessageType_Audio,

    //客服欢迎消息(只能获取)
    MessageType_UsWelcome,
    //企业欢迎消息(只能获取)
    MessageType_UnitWelcome,
    //自动回复
    MessageType_AutoReply,
}kMCMessageType;

/**
 * 消息方向枚举
 */
typedef enum{
    //发送
    MessageOwner_Send         = 0,
    //接收
    MessageOwner_Receive
}kMCMessageDirection;

typedef enum{
    //发送中
    SentStatus_Sending        = 0,
    //发送失败
    SentStatus_Failed,
    //已送达
    SentStatus_Arrived
}kMCSentStatus;

/**
 * 客服分配 类型
 */
typedef enum{
    //自动分配客服
    ServiceEvent_SystemAlloc  = 0,
    //人为转接
    ServiceEvent_ServiceRedirect,
    //系统转接（如：接待该用户的客服下线时，系统将自动转接给其他客服）
    ServiceEvent_SystemRedirect
}kMCServiceEventType;

/**
 * 网络连接类型
 */
typedef enum {
    MCNetworkType_None        = 0,
    MCNetworkType_WiFi,
    MCNetworkType_2G,
    MCNetworkType_3G,
    MCNetworkType_4G
}kMCNetworkType;

/**
 * 异常或错误。没有异常时返回-1
 */
typedef enum{
    Exception_Error_Parameter = 0,//参数错误

    Exception_AppKey_Invalid,           //appkey无效
    Exception_Init_Failed,              //初始化中出现错误
    Exception_NotInitialized,           //未初始化

    Exception_User_IsOffline,           //顾客为离线状态，当前操作无法操作
    
    Exception_Connection_Error,         //网络请求错误
    Exception_User_BlackList,           //在用户在黑名单
    Exception_Server_NotOnline,         //没有客服在线
    
    Exception_ServiceError,             //服务器出错
    Exception_UnknownError              //未知错误
}kMCExceptionStatus;