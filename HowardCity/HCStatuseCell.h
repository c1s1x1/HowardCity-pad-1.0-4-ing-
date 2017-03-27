#import <UIKit/UIKit.h>
#import "HCStatuseCellFrame.h"

@interface HCStatuseCell : UITableViewCell

+(instancetype)cellWithTabbleView:(UITableView *)tableView;

/**
 * 在set方法实现子控件显示
 */
@property(nonatomic,strong)HCStatuseCellFrame *statusCellFrm;

@end
