#import <Foundation/Foundation.h>
#import "HCStatuses.h"

@interface ProjectEntity : NSObject
{
    HCStatuses *statuse;
}

@property(nonatomic,retain) HCStatuses *statuse;

@end
