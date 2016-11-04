#import "MeiQiaCordovaPlugin.h"

@interface MeiQiaCordovaPlugin ()

- (void)sendErrorToDelegate:(NSString *)errorMessage;
@property(nonatomic, strong, readwrite) CDVInvokedUrlCommand *command;
// @property(nonatomic, strong, readwrite) MeiQiaConfiguration *configuration;

@end


#pragma mark -

@implementation MeiQiaCordovaPlugin

- (void)init:(CDVInvokedUrlCommand *)command {
  self.command = command;
  NSString *api = command.arguments[0];

  [MQManager initWithAppkey:api completion:^(NSString *clientId, NSError *error) {
      if (error) {
        [self sendErrorToDelegate:@"Could not initialize MeiQia"];
      } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:clientId];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      }
  }];
}

- (void)openChat:(CDVInvokedUrlCommand *)command {
  self.command = command;
  NSString *realname = command.arguments[0];
  // NSString *mobile = command.arguments[1];

  NSDictionary* userInfo =  @{
    @"name"     : realname,
    // @"tel"      : mobile,
  };
  MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
  [chatViewManager setClientInfo:userInfo];

  [chatViewManager enableSyncServerMessage:false];

  [chatViewManager.chatViewStyle setEnableOutgoingAvatar:false];
  [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
  [chatViewManager.chatViewStyle setNavBarTintColor:[UIColor whiteColor]];
  [chatViewManager.chatViewStyle setNavTitleColor:[UIColor whiteColor]];
  [chatViewManager.chatViewStyle setNavBarColor:[UIColor colorWithRed:0.941 green:0.353 blue:0.314 alpha:1.0]];
  [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
  [chatViewManager.chatViewStyle setStatusBarStyle: UIStatusBarStyleLightContent];

  [chatViewManager pushMQChatViewControllerInViewController:self.viewController];

  // [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectEnterprise];
  // [chatViewManager setRecordMode:MQRecordModeDuckOther];
  // [chatViewManager setPlayMode:MQPlayModeMixWithOther];
  // [[UINavigationBar appearance] setTranslucent:NO];

  [MQManager openMeiqiaService];

}

- (void)updateClientInfo:(CDVInvokedUrlCommand *)command {
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)closeChat:(CDVInvokedUrlCommand *)command {
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)setOffline:(CDVInvokedUrlCommand *)command {
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

// - (void)init:(CDVInvokedUrlCommand *)command {
//   // self.command = command;
//   // NSString *realname = @"iOS";// command.arguments[0];
//   // NSString *mobile = @"tester";// command.arguments[1];
//   //
//   NSDictionary* userInfo =  @{
//     @"name"     : @"iOS",//realname,
//     @"tel"      : @"tester", //mobile,
//   };
//   // NSString *realname = @"iOS";// command.arguments[0];
//
//   [MQManager initWithAppkey:@"a548e3b25552571820ac28fe1b9b5505" completion:^(NSString *clientId, NSError *error) {
//       if (!error) {
//         NSLog(@"美洽 SDK：初始化成功:%@", clientId);
//           MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
//           [chatViewManager setClientInfo:userInfo];
//
//           [chatViewManager enableSyncServerMessage:false];
//
//           [chatViewManager.chatViewStyle setEnableOutgoingAvatar:false];
//           [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
//           [chatViewManager.chatViewStyle setNavBarTintColor:[UIColor whiteColor]];
//           [chatViewManager.chatViewStyle setNavTitleColor:[UIColor whiteColor]];
//           [chatViewManager.chatViewStyle setNavBarColor:[UIColor colorWithRed:0.941 green:0.353 blue:0.314 alpha:1.0]];
//           [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
//
//           [chatViewManager pushMQChatViewControllerInViewController:self.viewController];
//
//
//           // [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectEnterprise];
//
//           // [chatViewManager.chatViewStyle setStatusBarStyle: UIStatusBarStyleLightContent];
//
//           // [chatViewManager setRecordMode:MQRecordModeDuckOther];
//           // [chatViewManager setPlayMode:MQPlayModeMixWithOther];
//
//
//           // [[UINavigationBar appearance] setTranslucent:NO];
//           [MQManager openMeiqiaService];
//
//       } else {
//           NSLog(@"error:%@",error);
//       }
//   }];
// }
//
//
// // - (void)openChat:(CDVInvokedUrlCommand *)command {
// //   [self.commandDelegate runInBackground:^{
// //     [MQManager openMeiqiaService];
// //
// //     CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
// //     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// //   }];
// // }
//
#pragma mark - Cordova convenience helpers

- (void)sendErrorToDelegate:(NSString *)errorMessage {
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:errorMessage];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

@end
