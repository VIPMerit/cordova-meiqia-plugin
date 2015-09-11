//
//  MCImageMessage.h
//  MeChatSDK
//
//  Created by Injoy on 14-9-17.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import "MCMessage.h"

@interface MCImageMessage : MCMessage

//图片的网络路径
@property (nonatomic,strong) NSString * fileUrl;
//图片的本地路径
@property (nonatomic,strong) NSString * filePath;

-(id)initWithFilePath:(NSString*)filePath;
-(id)initWithFileUrl:(NSString*)Url withFilePath:(NSString*)filePath;
@end
