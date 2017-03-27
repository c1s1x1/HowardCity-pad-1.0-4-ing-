#import <UIKit/UIKit.h>
#import "HCStatuseOriginalCellFrame.h"

@interface HCStatuseOriginalView : UIImageView

/**
 * 一定要传一个HCStatuseOriginalCellFrame 模型，内部才可以显示子控件
 */

@property(nonatomic,strong)HCStatuseOriginalCellFrame *originalFrm;

@end
