#import <Foundation/Foundation.h>
#import "HCTaskViewFrame.h"
#import "HCTask.h"

@interface HCTaskCellFrame : NSObject

/**
 * HCStatuseDetailView的frm模型
 */
@property(nonatomic,strong)HCTaskViewFrame *TaskFrm;

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
