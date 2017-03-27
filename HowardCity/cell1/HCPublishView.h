#import <UIKit/UIKit.h>
#import "HCPublishViewFrame.h"

@interface HCPublishView : UIImageView

/**
 * 一定要传一个HCPublishViewFrame 模型，内部才可以显示子控件
 */

@property(nonatomic,strong)HCPublishViewFrame *PublishFrm;

@end
