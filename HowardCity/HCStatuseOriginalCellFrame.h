#import <Foundation/Foundation.h>
#import "HCStatuses.h"

@interface HCStatuseOriginalCellFrame : NSObject

/**
 * 项目图片Frm
 */
@property(nonatomic,assign)CGRect profileFrm;

/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect screenNameFrm;
/**
 * 人数和空余空间Frm
 */
@property(nonatomic,assign)CGRect PersonAndSpaceLabelFrm;

/**
 * SPI进度Frm
 */
@property(nonatomic,assign)CGRect SPIFrm;
@property(nonatomic,assign)CGRect SPILableFrm;

/**
 * CPI进度Frm
 */
@property(nonatomic,assign)CGRect CPIFrm;
@property(nonatomic,assign)CGRect CPILableFrm;
/**
 * SV进度Frm
 */
@property(nonatomic,assign)CGRect SVFrm;
@property(nonatomic,assign)CGRect SVLableFrm;

/**
 * CV进度Frm
 */
@property(nonatomic,assign)CGRect CVFrm;
@property(nonatomic,assign)CGRect CVLableFrm;

/**
 * 创建者Frm
 */
@property(nonatomic,assign)CGRect UserNameFrm;

/**
 * 创建时间Frm
 */
@property(nonatomic,assign)CGRect BuildTimeFrm;

/**
 * 项目详情Frm
 */
@property(nonatomic,assign)CGRect InformationFrm;

/**
 * 分割线Frm
 */
@property(nonatomic,assign)CGRect HighLightFrm;


/**
 * HCStatusOriginalView(原创微博View的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

@property(nonatomic,strong)HCStatuses *statuse;

@end
