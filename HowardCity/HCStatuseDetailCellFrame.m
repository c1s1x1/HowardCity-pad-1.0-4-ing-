#import "HCStatuseDetailCellFrame.h"

@implementation HCStatuseDetailCellFrame

-(void)setStatuse:(HCStatuses *)statuse{
    _statuse = statuse;
    
    // 给originalFrm模型设置值
    HCStatuseOriginalCellFrame *originalFrm = [[HCStatuseOriginalCellFrame alloc] init];
    originalFrm.statuse = statuse;
    self.originalFrm = originalFrm;
    
    
    // 设置selfFrm
    CGFloat selfH = CGRectGetMaxY(originalFrm.selfFrm);
    
    self.selfFrm = CGRectMake(0, 10, UIScreenW, selfH);
}

@end
