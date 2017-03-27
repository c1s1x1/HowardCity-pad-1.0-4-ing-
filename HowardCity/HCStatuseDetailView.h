#import <UIKit/UIKit.h>
#import "HCStatuseDetailCellFrame.h"

@interface HCStatuseDetailView : UIView

/**
 * 一定要传一个HCStatuseDetailCellFrame 模型，内部才可以显示子控件
 */
@property(strong,nonatomic)HCStatuseDetailCellFrame *detailFrm;

@end
