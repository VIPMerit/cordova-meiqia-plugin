#import <Cordova/CDV.h>
#import "CDVMC.h"
#import <MQSDK/MQChatViewManager.h>
#import <MeiQiaSDK/MQManager.h>

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
        [MQManager setClientInfo:userInfo completion:^(BOOL success, NSError *error) {
        }];
    }];
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager enableSyncServerMessage:true];
    [chatViewManager setNavigationBarTintColor:[UIColor whiteColor]];
    [chatViewManager setNavigationBarColor:[UIColor colorWithRed:0.94 green:0.35 blue:0.31 alpha:1.0]];
    [chatViewManager setNavigationBarStyle:UIStatusBarStyleLightContent];
    [chatViewManager pushMQChatViewControllerInViewController:self.viewController];
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}
@end