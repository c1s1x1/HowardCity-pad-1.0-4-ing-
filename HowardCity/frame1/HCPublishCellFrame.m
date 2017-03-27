#import "HCPublishCellFrame.h"

@implementation HCPublishCellFrame

-(void)setTask:(HCTask *)Task{
    _Task = Task;
    
    //给detialFrm设值
    HCPublishViewFrame *PublishFrm = [[HCPublishViewFrame alloc] init];
    PublishFrm.Task = Task;
    self.PublishFrm = PublishFrm;
    
    //给toolBar 设置值
    CGFloat toolbarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(PublishFrm.selfFrm);
    self.toolBarFrm = CGRectMake(toolbarX, toolBarY, UIScreenW, 10);
}

-(CGFloat)cellHeight{
    return CGRectGetMaxY(self.toolBarFrm);
}
 
@end
