#import "HCStatuseCellFrame.h"

@implementation HCStatuseCellFrame

-(void)setStatuse:(HCStatuses *)statuse{
    _statuse = statuse;
    
    // 给originalFrm模型设置值
    HCStatuseOriginalCellFrame *originalFrm = [[HCStatuseOriginalCellFrame alloc] init];
    originalFrm.statuse = statuse;
    self.originalFrm = originalFrm;
    
    //给toolBar 设置值
    CGFloat toolbarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(originalFrm.selfFrm);
    self.toolBarFrm = CGRectMake(toolbarX, toolBarY, UIScreenW, 30);
}

-(CGFloat)cellHeight{
    return CGRectGetMaxY(self.toolBarFrm);
}

@end
