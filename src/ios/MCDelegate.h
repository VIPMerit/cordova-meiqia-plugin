//
//  MCDelegate.h
//  MeChatSDK
//
//  Created by Injoy on 14-8-4.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCService.h"
#import "MCDefination.h"
#import "MCTextMessage.h"

@protocol MCExpcetionDelegate <NSObject>
@optional
/**
 * 发生异常
 * @param status 异常类型
 * @param description 异常描述
 */
-(void)receivedExpcetionStatus:(kMCExceptionStatus)staus desc:(NSString*)description;
@end

@protocol MCConnectDelegate <NSObject>
/**
 * 设置用户上线结果
 * @param result 是否上线成功。若设备非网络故障，说明当前没有客服在线，建议使用留言接口继续服务
 * @param service 如果上线成功，返回客服信息
 * @param expcetion 如果成功，expcetion为-1
 */
-(void)userOnlineResult:(BOOL)result service:(MCService*)service expcetion:(kMCExceptionStatus)expcetion;
@optional
/**
 * 异步执行用户下线结果
 */
-(void)userOffOnlineResult:(BOOL)result;
@end

@protocol MCMessageDelegate <NSObject>
/**
 * 收到即时消息
 * @param messages 消息数组，元素为MCMessage类型
 */
-(void)receiveMessage:(NSArray*)messages;

@optional
/**
 * 发送消息结果
 * @param message 发送后的消息（包含该消息当前发送状态）
 * @param expcetion 失败原因（如果为-1，则代表发送成功）
 */
-(void)sendMessageResult:(MCMessage*)message expcetion:(kMCExceptionStatus)expcetion;

/**
 * 收到事件
 * @param Event 事件数组，元素为MCEvent类型
 */
-(void)receiveEvent:(NSArray*)Event;

/**
 * 获取网络消息完成
 * @param messages 消息数组，元素为MCMessage类型
 * @param remain 剩余消息数量
 * @param expcetion 如果获取失败，messages值为nil
 */
-(void)getNetMessageResult:(NSArray*)messages remain:(int)remain expcetion:(kMCExceptionStatus)expcetion;

/**
 * 客服正在输入的消息
 */
-(void)serviceInputting;
@end

@protocol MCAudioRecordDelegate <NSObject>
@optional
/**
 * 录音中的说话声音大小
 * @param volume 声音大小,范围为0-1
 */
-(void)recordingInVolume:(float)volume;

/**
 * 录音自动终止。比如录制时间超过1分钟
 */
-(void)recordStop;

/**
 * 录音语音中接收到错误.如果发生错误，美洽将中断录音，且录音不会发送。
 * @param error 错误原因
 */
-(void)recordError:(NSError*)error;
@end