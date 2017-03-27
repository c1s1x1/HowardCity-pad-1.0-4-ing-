#import <Foundation/Foundation.h>
#import "HCTask.h"

@interface HCTaskViewFrame : NSObject

/**
 * 任务标题Frm
 */
@property(nonatomic,assign)CGRect TaskTopViewFrm;
/**
 * 任务状态Frm
 */
@property(nonatomic,assign)CGRect TaskFormFrm;
/**
 * 任务名称Frm
 */
@property(nonatomic,assign)CGRect TaskNameFrm;

/**
 * 任务类型Frm
 */
@property(nonatomic,assign)CGRect TaskTypeFrm;
/**
 * 任务发布者Frm
 */
@property(nonatomic,assign)CGRect TaskUserNameFrm;
/**
 * 任务状态Frm
 */
@property(nonatomic,assign)CGRect TaskStateFrm;

/**
 * 用户任务执行状态Frm
 */
@property(nonatomic,assign)CGRect HoperaTionsFrm;
/**
 * 横分割线Frm
 */
@property(nonatomic,assign)CGRect HighlightViewAFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect BuildTimeFrm;
/**
 * 竖分割线Frm
 */
@property(nonatomic,assign)CGRect HighlightViewBFrm;
/**
 * 任务截止时间Frm
 */
@property(nonatomic,assign)CGRect DeadLineFrm;
/**
 * HCStatusOriginalView(原创微博View的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

@property(nonatomic,strong)HCTask *Task;

@end
