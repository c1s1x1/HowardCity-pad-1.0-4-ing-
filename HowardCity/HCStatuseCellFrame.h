#import <Foundation/Foundation.h>
#import "HCStatuseOriginalCellFrame.h"
#import "HCStatuses.h"

@interface HCStatuseCellFrame : NSObject

/**
 * 项目Frm 模型
 */
@property(nonatomic,strong)HCStatuseOriginalCellFrame *originalFrm;

/**
 * 传一个项目模型，内部计算frm
 */
@property(nonatomic,strong)HCStatuses *statuse;

@property(nonatomic,assign)CGRect toolBarFrm;

/**
 * 计算CELL高度
 */
-(CGFloat)cellHeight;

@end
