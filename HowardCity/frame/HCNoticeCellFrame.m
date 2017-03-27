#import "HCNoticeCellFrame.h"

@implementation HCNoticeCellFrame

-(void)setNotice:(HCNotice *)Notice{
    _Notice = Notice;
    
    //给detialFrm设值
    HCNoticeViewFrame *NoticeFrm = [[HCNoticeViewFrame alloc] init];
    NoticeFrm.Notice = Notice;
    self.NoticeFrm = NoticeFrm;
    
    //给toolBar 设置值
    CGFloat toolbarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(NoticeFrm.selfFrm);
    self.toolBarFrm = CGRectMake(toolbarX, toolBarY, UIScreenW, 10);
}

-(CGFloat)cellHeight{
    return CGRectGetMaxY(self.toolBarFrm);
}
 
@end
