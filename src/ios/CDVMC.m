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
                                @"realName"     : realname,
                                @"tel"       : mobile,
                                };

    [MQManager initWithAppkey:@"cab23cf1f964306751d12b8eb29f8959" completion:^(NSString *clientId, NSError *error) {
        [MQManager setClientInfo:userInfo completion:^(BOOL success, NSError *error) {
        }];
    }];
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager enableSyncServerMessage:true];
    [chatViewManager pushMQChatViewControllerInViewController:self.viewController];
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}
@end
