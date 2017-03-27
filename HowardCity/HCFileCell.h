#import <UIKit/UIKit.h>
#import "HCFileCellFrame.h"

@interface HCFileCell : UITableViewCell

+(instancetype)cellWithTabbleView:(UITableView *)tableView;

/**
 * 在set方法实现子控件显示
 */
@property(nonatomic,strong)HCFileCellFrame *FileCellFrm;

@end
