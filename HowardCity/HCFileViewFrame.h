#import <Foundation/Foundation.h>
#import "HCFilerecord.h"

@interface HCFileViewFrame : NSObject

/**
 * 项目图片Frm
 */
@property(nonatomic,assign)CGRect profileFrm;

/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect screenNameFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect CreateTimeFrm;



/**
 * HCStatusOriginalView(原创微博View的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

@property(nonatomic,strong)HCFilerecord *Filerecord;

@end
