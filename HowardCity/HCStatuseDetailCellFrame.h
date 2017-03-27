#import <Foundation/Foundation.h>
#import "HCStatuseOriginalCellFrame.h"

@interface HCStatuseDetailCellFrame : NSObject

/**
 * 项目Frm 模型
 */
@property(nonatomic,strong)HCStatuseOriginalCellFrame *originalFrm;

/**
 * 详情View(HCStatuseDetailView的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

/**
 * 设置项目模型，内部计算frm
 */
@property(nonatomic,strong)HCStatuses *statuse;

@end
