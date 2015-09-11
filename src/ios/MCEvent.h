//
//  MCEvent.h
//  MeChatSDK
//
//  Created by Injoy on 14-9-9.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCService.h"

@interface MCEvent : NSObject

@property (nonatomic,assign) long long           createTime;
@property (nonatomic,assign) kMCServiceEventType eventType;
@property (nonatomic,strong) MCService           * service;

@property (nonatomic,strong) MCService           * targetService;//转接的目标客服（转接事件才会有值）
@end
