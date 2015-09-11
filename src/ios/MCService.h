//
//  MCService.h
//  MeChatSDK
//
//  Created by Injoy on 14-8-5.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMessage.h"

@interface MCService : NSObject <NSCopying>

//客服id
@property (nonatomic,strong) NSString       * userviceId;
//客服名
@property (nonatomic,strong) NSString       * userviceName;
//客服头像
@property (nonatomic,strong) NSString       * userviceAvatar;
//客服所属企业名
@property (nonatomic,strong) NSString       * unitName;
//企业LOGO
@property (nonatomic,strong) NSString       * unitLogo;

//自动应答消息
@property (nonatomic,strong) MCMessage      * autoReplyMessage;
//自动应答时间间隔
@property (nonatomic,assign) NSTimeInterval autoReplyInterval;

@end
