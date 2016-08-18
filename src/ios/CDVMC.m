#import <Cordova/CDV.h>
#import "CDVMC.h"
#import <MeiQiaSDK/MQManager.h>
#import "MQChatViewManager.h"

@interface CDVMC ()
@property(nonatomic, strong) CDVInvokedUrlCommand *command;
@end

@implementation CDVMC

- (void)meiQia:(CDVInvokedUrlCommand*)command
{
    self.command = command;
    NSString *realname = command.arguments[0];
    NSString *mobile = command.arguments[1];
    
    NSDictionary* userInfo =  @{
                                @"name"     : realname,
                                @"tel"       : mobile,
                                };


    [MQManager initWithAppkey:@"cab23cf1f964306751d12b8eb29f8959" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功:%@", clientId);
        } else {
            NSLog(@"error:%@",error);
        }
    }];

    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager enableSyncServerMessage:false];
    [chatViewManager pushMQChatViewControllerInViewController:self];
    [chatViewManager setNavigationBarTintColor:[UIColor whiteColor]];
    [chatViewManager setNavigationBarColor: [UIColor colorWithRed:0.941 green:0.353 blue:0.314 alpha:1.0]];
    [chatViewManager setNavigationBarStyle:UIStatusBarStyleLightContent];
    [chatViewManager setClientInfo:userInfo];
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}
@end