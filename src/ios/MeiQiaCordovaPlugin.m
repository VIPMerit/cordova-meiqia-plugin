#import "MeiQiaCordovaPlugin.h"

@interface MeiQiaCordovaPlugin ()

- (void)sendErrorToDelegate:(NSString *)errorMessage;
@property(nonatomic, strong, readwrite) CDVInvokedUrlCommand *command;
// most likely should be weak
@property(nonatomic, strong, readwrite) MQChatViewController *chatViewInstance;
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

- (void)updateClientInfo:(CDVInvokedUrlCommand *)command {
  NSArray* arguments = [command arguments];
  NSDictionary* args = [arguments firstObject];
  NSDictionary* clientCustomizedAttrs;
  if([args objectForKey:@"spreeId"] != nil) {
    clientCustomizedAttrs = @{
      @"name": [args objectForKey:@"name"],
      @"spreeId": [args objectForKey:@"spreeId"],
      @"haishangId": [args objectForKey:@"haishangId"],
      @"phone": [args objectForKey:@"phone"],
    };
  } else {
    clientCustomizedAttrs = @{@"haishangId": [args objectForKey:@"haishangId"]};
  }

  [MQManager setClientInfo:clientCustomizedAttrs completion:^(BOOL success, NSError *error) {
    if (success) {
      CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
      [self sendErrorToDelegate:@"Could not update client info"];
    }
  }];
}

- (void)openChat:(CDVInvokedUrlCommand *)command {
    self.chatViewInstance = Nil;
    NSArray* arguments = [command arguments];
    NSDictionary* args = [arguments firstObject];
    NSDictionary* clientCustomizedAttrs;
    NSString *customizedId = [args objectForKey:@"haishangId"];
    if([args objectForKey:@"spreeId"] != nil) {
        clientCustomizedAttrs = @{
                                  @"name": [args objectForKey:@"name"],
                                  @"spreeId": [args objectForKey:@"spreeId"],
                                  @"gender": [args objectForKey:@"haishangId"],
                                  @"tel": [args objectForKey:@"tel"],
                                  @"age": [args objectForKey:@"supportReferrer"],
                                  };
    } else {
        clientCustomizedAttrs = @{@"haishangId": [args objectForKey:@"haishangId"]};
    }

    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setClientInfo:clientCustomizedAttrs override:YES];
    [chatViewManager setLoginCustomizedId: customizedId];
    [chatViewManager setMessageLinkRegex:@"(haishang://[^\\s]*)"];
    [chatViewManager.chatViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    [chatViewManager.chatViewStyle setNavBarTintColor:[UIColor colorWithRed:238/255.0 green:195/255.0 blue:147/255.0 alpha:1.0]];
    [chatViewManager.chatViewStyle setNavTitleColor:[UIColor colorWithRed:238/255.0 green:195/255.0 blue:147/255.0 alpha:1.0]];
    [chatViewManager.chatViewStyle setNavBarColor:[UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0]];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    [[UINavigationBar appearance] setTranslucent:NO];
    self.chatViewInstance = [chatViewManager pushMQChatViewControllerInViewController:self.viewController];
    // styling
    // [chatViewManager enableSyncServerMessage:false];
    // [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectEnterprise];
    // [chatViewManager setRecordMode:MQRecordModeDuckOther];
    // [chatViewManager setPlayMode:MQPlayModeMixWithOther];
    [MQManager openMeiqiaService];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)closeChat:(CDVInvokedUrlCommand *)command {
  [MQManager closeMeiqiaService];
  [self.chatViewInstance dismissChatViewController];
  self.chatViewInstance = Nil;
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)setOffline:(CDVInvokedUrlCommand *)command {
  [MQManager setClientOffline];
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

#pragma mark - Cordova convenience helpers

- (void)sendErrorToDelegate:(NSString *)errorMessage {
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:errorMessage];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

@end
