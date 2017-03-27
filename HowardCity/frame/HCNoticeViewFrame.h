#import <Foundation/Foundation.h>
#import "HCNotice.h"

@interface HCNoticeViewFrame : NSObject

/**
 * 项目图片Frm
 */
@property(nonatomic,assign)CGRect NoticTitleFrm;

/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect SenderFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect SendTimeFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect IsvisitLabelFrm;
/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect InfoTypeLabelFrm;



/**
 * HCStatusOriginalView(原创微博View的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

@property(nonatomic,strong)HCNotice *Notice;

@end
