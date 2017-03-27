#import <Foundation/Foundation.h>
#import "HCFileViewFrame.h"
#import "HCFilerecord.h"

@interface HCFileCellFrame : NSObject

/**
 * HCStatuseDetailView的frm模型
 */
@property(nonatomic,strong)HCFileViewFrame *FileFrm;

/**
 * 传一个项目模型，内部计算frm
 */
@property(nonatomic,strong)HCFilerecord *Filerecord;

@property(nonatomic,assign)CGRect toolBarFrm;

/**
 * 计算CELL高度
 */
-(CGFloat)cellHeight;

@end
