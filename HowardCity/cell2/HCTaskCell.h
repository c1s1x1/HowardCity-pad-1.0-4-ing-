#import <UIKit/UIKit.h>
#import "HCTaskCellFrame.h"

@interface HCTaskCell : UITableViewCell

+(instancetype)cellWithTabbleView:(UITableView *)tableView;

/**
 * 在set方法实现子控件显示
 */
@property(nonatomic,strong)HCTaskCellFrame *TaskCellFrm;

@end
