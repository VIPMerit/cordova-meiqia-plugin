//
//  MCCore.h
//  MeChatSDK 当前版本: v1.2.1
//
//  开发文档链接：https://meiqia.com/docs/sdk/ios.html
//
//  Copyright (c) 2014年 MeChat. All rights reserved.
//
//  更新日志
//
//  更早更新日志，请查看：https://meiqia.com/sdk/index.html
//
//  v1.2.1 2015年9月11日
//      【添加】用户离线时接收客服消息的函数


#import <Foundation/Foundation.h>
#import "MCDelegate.h"
#import "MCTextMessage.h"
#import "MCImageMessage.h"
#import "MCAudioMessage.h"
#import "MCChatViewController.h"

//网络连接类型监测。将此字符串添加到NSNotificationCenter的观察者，可监测网络变化。详细介绍参考开发文档。
#define kMCNetworkStatusChange @"MCNetworkStatusChange"
//启用log打印，默认YES
#define MCEnabledLog YES

@interface MCCore : NSObject

/**
 * 初始化SDK
 * @param appkey 在美洽管理后台申请的appkey
 * @param delegate 可空，发生异常时的代理函数：-(void)receivedExpcetionStatus:desc:
 */
+(void)initWithAppkey:(NSString*)appkey expcetionDelegate:(id<MCExpcetionDelegate>)delegate;

/**
 * 平台客户/渠道客户 专用的初始化SDK接口
 * @param appkey 在美洽管理后台申请的appkey
 * @param innerName 商户/企业 的innerName，如果innerName为nil，那么等同于使用initWithAppkey:expcetionDelegate:
 * @param delegate 可空，发生异常时的代理函数：-(void)receivedExpcetionStatus:desc:
 */
+(void)initWithAppkey:(NSString*)appkey innerName:(NSString*)innerName expcetionDelegate:(id<MCExpcetionDelegate>)delegate;

/**
 * 设置用户开发者自定义该用户需要展示给客服的信息。键值都必须为字符串
 * @param userInfo 美洽已定义的用户信息。详见开发文档
 * @param otherInfo 其他信息，键值可以为任意字符串
 */
+(void)addUserInfo:(NSDictionary*)userInfo addOtherInfo:(NSDictionary*)otherInfo;

/**
 * 将该用户定向分配到组里面的客服，需要在用户上线前设置
 * @param groupId 组的ID
 */
+(void)specifyAllocGroup:(NSString*)groupId;

/**
 * 将该用户定向分配到某个客服，需要在用户上线前设置。若与specifyAllocGroup冲突，系统将根据后台所设置的客服优先级分配
 * @param serverId 客服的ID
 * @param force 是否强制分配到该客服。如果不强制，若该客服不在线，会分配给其他客服
 */
+(void)specifyAllocServer:(NSString*)serverId isForce:(BOOL)force;

/**
 * 设置用户上线
 * @param metadata 可以为空，但如果赋值，键值必须为字符串。自定义该用户自定义信息，用于显示给客服看
 * @param delegate 不能为空，结果通过代理函数：-(void)userOnlineResult:Service:networkFault:
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(void)letUserOnlineWithDelegate:(id<MCConnectDelegate>)delegate;

/**
 * 创建聊天界面。MCChatViewController是美洽实现MCCore功能的体现。
 */
+(MCChatViewController*)createChatViewController;

/**
 * 设置用户离线，离线后APP将无法收到消息。该方法为同步执行，用于AppDelegate中的applicationDidEnterBackground:
 * @param deviceToken 设备唯一标识，用于推送服务;
 */
+(BOOL)letUserOffOnlineIsSynchronizationWithDeviceToken:(NSString*)deviceToken;

/**
 * 设置用户离线，离线后APP将无法收到消息。该方法为异步执行，该方法常建议用于viewDidDisappear、viewWillDisappear中。
 * 提醒：MCChatViewController已实现该接口，但仍需设置MCChatViewController字段中的deviceToken才能生效。
 * @param delegate 下线结果将调用代理函数：-(void)userOffOnlineResult:
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(void)letUserOffOnlineIsAsynchronousWithDeviceToken:(NSString*)deviceToken delegate:(id<MCConnectDelegate>)delegate;

/**
 * 接收推送消息
 * @param appUserId 在函数 addUserInfo:addOtherInfo: 中上传的用户id。没有可以为nil
 * @param delegate 收到推送消息的代理函数：-(void)receivePush:
 */
+(void)receivePushWithAppUserId:(NSString*)appUserId delegate:(id<MCPushDelegate>)delegate;

/**
 * 获得历史消息。如length=10，startIndex=30，那么获取到的就是第31-40的10条消息
 * @param length 获取的消息数量
 * @param startIndex 该位置作为获取的起始消息，用于分页。
 */
+(NSArray*)getMessageWithNumber:(int)length startIndex:(int)startIndex;

/**
 * 获得历史事件。如length=10，startIndex=30，那么获取到的就是第31-40的10条事件
 * @param length 获取的事件数量
 * @param startIndex 该位置作为获取的起始事件，用于分页。
 */
+(NSArray*)getEventWithNumber:(int)length startIndex:(int)startIndex;

/**
 * 获取服务器上的消息。
 * @param length 获取的事件数量
 * @param startIndex 该位置作为获取的起始事件，用于分页。如果获取最近消息length条消息，请传-1
 */
+(void)getNetMessageWithNumber:(int)length startIndex:(int)startIndex delegate:(id<MCMessageDelegate>)delegate;

/**
 * 发送文字消息
 * @param content 消息内容。会做前后去空格处理，处理后的消息长度不能为0，否则不执行发送操作
 * @param delegate 发送消息的代理，如果发送成功，会返回完整的消息对象，代理函数：-(void)sendMessageResult:expcetion:
 * @return 该条文字消息。此时该消息状态为发送中.
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(MCTextMessage*)sendTextMessageWithContent:(NSString*)content delegate:(id<MCMessageDelegate>)delegate;

/**
 * 发送图片消息。该函数会做图片压缩操作，尺寸将会限制在最大1280px
 * @param image 图片
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)sendMessageResult:expcetion:
 * @return 该条图片消息。此时该消息状态为发送中，且只有本地图片路径（已压缩），没有网络图片路径
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(MCImageMessage*)sendImageMessageWithFile:(UIImage*)image delegate:(id<MCMessageDelegate>)delegate;


/********************************
  使用美洽的接口控制录制语音消息，在录制过程中便开始分片发送语音消息。
  网络状态良好的情况下，结束录制时，消息就已经发送成功，极大提升用户体验。
 ********************************/

/**
 * 开始录制并发送语音消息。该接口实现了语音录制功能。
 * @param recordDelegate 可空。录制语音的代理，为开发者提供一些扩展信息。
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)sendMessageResult:expcetion:
 * @return 该条语音消息。此时该消息状态为发送中，且只有本地语音路径(filePath)，该路径的语音正在录制中.
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(MCAudioMessage*)startRecordingAndSendAudioMessage:(id<MCAudioRecordDelegate>)recordDelegate delegate:(id<MCMessageDelegate>)delegate;
/**
 * 停止录音并且确认发送该语音消息。
 */
+(void)stopRecordingAudioMessage;
/**
 * 停止录音并取消发送。如用户取消发送、有来电等情况时，需调用该函数。
 */
+(void)cancelSendAudioMessage;

/**
 * 发送语音消息。使用该接口，需要开发者提供一条amr格式的语音.
 * @param audio 需要发送的语音消息，格式为amr。
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)sendMessageResult:expcetion:
 * @return 该条语音消息。此时该消息状态为发送中，且只有本地语音路径.
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(MCAudioMessage*)sendAudioMessage:(NSData*)audio delegate:(id<MCMessageDelegate>)delegate;

/**
 * 重发失败状态的消息，如果该用户没有客服接待，那么该消息将以留言的方式发送。
 * @param message 消息实体
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)sendMessageResult:expcetion:
 * @return 该条消息实体，类型为MCTextMessage或MCImageMessage。
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(MCMessage*)resendMessageWithFailedMessage:(MCMessage*)message delegate:(id<MCMessageDelegate>)delegate;

/**
 * 将用户正在输入的内容，提供给客服查看。该接口没有调用限制，但每1秒内只会向服务器发送一次数据
 * @param content 提供给客服看到的内容
 */
+(void)userInputting:(NSString*)content;

/**
 * 处理接受到的即使消息和事件
 * @param delegate 处理收到的消息的回调函数，包括 即时消息、转接、正在输入 的回调函数：-(void)receiveEvent:
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+(void)handleReceiveMessageAndEventWithDelegate:(id<MCMessageDelegate>)delegate;

/**
 * 获取当前网络状态
 */
+(kMCNetworkType)getNetworkStatus;

/**
 * 获得当前组件版本号
 */
+(NSString*)getLibraryVersion;

@end
