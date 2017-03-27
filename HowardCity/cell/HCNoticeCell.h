#import <UIKit/UIKit.h>
#import "HCNoticeCellFrame.h"

@interface HCNoticeCell : UITableViewCell

+(instancetype)cellWithTabbleView:(UITableView *)tableView;

/**
 * 在set方法实现子控件显示
 */
@property(nonatomic,strong)HCNoticeCellFrame *NoticeCellFrm;

@end
