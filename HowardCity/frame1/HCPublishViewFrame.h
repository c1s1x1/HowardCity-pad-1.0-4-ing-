#import <Foundation/Foundation.h>
#import "HCTask.h"

@interface HCPublishViewFrame : NSObject

/**
 * 项目图片Frm
 */
@property(nonatomic,assign)CGRect TaskNameFrm;

/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect TaskTypeFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect BuildTimeFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect TaskStateFrm;

/**
 * HCStatusOriginalView(原创微博View的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

@property(nonatomic,strong)HCTask *Task;

@end
