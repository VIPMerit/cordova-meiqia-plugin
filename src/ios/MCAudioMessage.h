//
//  MCAudioMessage.h
//  MeChatSDK
//
//  Created by Injoy on 14/11/20.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMessage.h"

@interface MCAudioMessage : MCMessage

//声音的网络路径
@property (nonatomic,strong) NSString  * fileUrl;
//声音的本地路径
@property (nonatomic,strong) NSString  * filePath;

-(id)initWithFilePath:(NSString*)filePath;

-(id)initWithAudioFile:(NSData*)audioFile;

-(id)initWithFileUrl:(NSString*)Url withFilePath:(NSString*)filePath;

@end
