#import <Foundation/Foundation.h>
@class UserEntity;

@protocol PassValueDelegate <NSObject>

-(void)passValue:(UserEntity *)value;

@end
