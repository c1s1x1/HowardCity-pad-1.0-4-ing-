#import <UIKit/UIKit.h>
#import "HCFileViewFrame.h"

@interface HCFileView : UIImageView

/**
 * 一定要传一个HCFileViewFrame 模型，内部才可以显示子控件
 */

@property(nonatomic,strong)HCFileViewFrame *FileFrm;

@end
