#import <Foundation/Foundation.h>
#import "HCAccount.h"

@interface HCAuthTool : NSObject

+(void)SaveAccount:(HCAccount *)account;


+(BOOL)IsLogin;


+(HCAccount *)user;

@end
