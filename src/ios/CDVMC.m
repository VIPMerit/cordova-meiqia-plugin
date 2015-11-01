#import <Cordova/CDV.h>
#import "CDVMC.h"
#import "MCCore.h"

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
    NSDictionary* otherInfo = @{};
    
    [MCCore initWithAppkey:@"55f2b5034eae35e70b000008" expcetionDelegate:nil];
    [MCCore addUserInfo:userInfo addOtherInfo:otherInfo];
    
    CDVMCHideViewController* parentController = [[CDVMCHideViewController alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:parentController];
    
    MCChatViewController* chatController = [MCCore createChatViewController];
    
    // custom navigationBar color
    navController.navigationBar.translucent = NO;
    navController.navigationBar.barTintColor = [UIColor colorWithRed:0.94 green:0.35 blue:0.31 alpha:1.0];;
    navController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    chatController.navigationBarTintColor = [UIColor whiteColor];
    
    [navController pushViewController:chatController animated:YES];
    [self.viewController presentViewController:navController animated:YES completion:nil];
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}
@end

@implementation CDVMCHideViewController
@synthesize CDVMC;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
