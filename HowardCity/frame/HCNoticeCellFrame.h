#import <Foundation/Foundation.h>
#import "HCNoticeViewFrame.h"
#import "HCNotice.h"

@interface HCNoticeCellFrame : NSObject

/**
 * HCStatuseDetailView的frm模型
 */
@property(nonatomic,strong)HCNoticeViewFrame *NoticeFrm;

/**
 * 传一个项目模型，内部计算frm
 */
@property(nonatomic,strong)HCNotice *Notice;

@property(nonatomic,assign)CGRect toolBarFrm;

/**
 * 计算CELL高度
 */
-(CGFloat)cellHeight;

@end
