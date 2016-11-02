#import <Cordova/CDV.h>
#import "CDVMC.h"
#import <MeiQiaSDK/MQManager.h>
#import <MeiQiaUI/MQChatViewManager.h>

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


    [MQManager initWithAppkey:@"a548e3b25552571820ac28fe1b9b5505" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功:%@", clientId);

            MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
            [chatViewManager setClientInfo:userInfo];

            [chatViewManager enableSyncServerMessage:false];

            [chatViewManager.chatViewStyle setEnableOutgoingAvatar:false];
            [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
            [chatViewManager.chatViewStyle setNavBarTintColor:[UIColor whiteColor]];
            [chatViewManager.chatViewStyle setNavTitleColor:[UIColor whiteColor]];
            [chatViewManager.chatViewStyle setNavBarColor:[UIColor colorWithRed:0.941 green:0.353 blue:0.314 alpha:1.0]];
            [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];

            [chatViewManager pushMQChatViewControllerInViewController:self.viewController];


            // [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectEnterprise];

            // [chatViewManager.chatViewStyle setStatusBarStyle: UIStatusBarStyleLightContent];

            // [chatViewManager setRecordMode:MQRecordModeDuckOther];
            // [chatViewManager setPlayMode:MQPlayModeMixWithOther];


            // [[UINavigationBar appearance] setTranslucent:NO];
        } else {
            NSLog(@"error:%@",error);
        }
    }];
    [MQManager openMeiqiaService];


}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}
@end
