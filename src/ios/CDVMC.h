#import <Cordova/CDVPlugin.h>

@interface CDVMC : CDVPlugin

+ (NSString*)cordovaVersion;

- (void)meiQia:(CDVInvokedUrlCommand*)command;

@end

@interface CDVMCHideViewController : UIViewController
{}
@property (nonatomic, strong) CDVPlugin* CDVMC;

@end
