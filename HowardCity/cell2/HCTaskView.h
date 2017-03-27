#import <UIKit/UIKit.h>
#import "HCTaskViewFrame.h"

@interface HCTaskView : UIImageView

/**
 * 一定要传一个HCTaskViewFrame 模型，内部才可以显示子控件
 */

@property(nonatomic,strong)HCTaskViewFrame *TaskFrm;

@end
