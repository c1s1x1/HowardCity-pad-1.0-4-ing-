#import <UIKit/UIKit.h>
#import "HCPublishCellFrame.h"

@interface HCPublishCell : UITableViewCell

+(instancetype)cellWithTabbleView:(UITableView *)tableView;

/**
 * 在set方法实现子控件显示
 */
@property(nonatomic,strong)HCPublishCellFrame *PublishCellFrm;

@end
