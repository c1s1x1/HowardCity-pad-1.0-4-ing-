#import <Foundation/Foundation.h>
#import "HCPublishViewFrame.h"
#import "HCTask.h"

@interface HCPublishCellFrame : NSObject

/**
 * HCStatuseDetailView的frm模型
 */
@property(nonatomic,strong)HCPublishViewFrame *PublishFrm;

/**
 * 传一个项目模型，内部计算frm
 */
@property(nonatomic,strong)HCTask *Task;

@property(nonatomic,assign)CGRect toolBarFrm;

/**
 * 计算CELL高度
 */
-(CGFloat)cellHeight;

@end
