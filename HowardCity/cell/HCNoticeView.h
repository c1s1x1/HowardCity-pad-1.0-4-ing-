#import <UIKit/UIKit.h>
#import "HCNoticeViewFrame.h"

@interface HCNoticeView : UIImageView

/**
 * 一定要传一个HCNoticeViewFrame 模型，内部才可以显示子控件
 */

@property(nonatomic,strong)HCNoticeViewFrame *NoticeFrm;

@end
