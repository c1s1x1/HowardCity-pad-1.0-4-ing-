#import "HCFileCellFrame.h"

@implementation HCFileCellFrame

-(void)setFilerecord:(HCFilerecord *)Filerecord{
    _Filerecord = Filerecord;
    
    //给detialFrm设值
    HCFileViewFrame *FileFrm = [[HCFileViewFrame alloc] init];
    FileFrm.Filerecord = Filerecord;
    self.FileFrm = FileFrm;
    
    //给toolBar 设置值
    CGFloat toolbarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(FileFrm.selfFrm);
    self.toolBarFrm = CGRectMake(toolbarX, toolBarY, UIScreenW, 10);
}

-(CGFloat)cellHeight{
    return CGRectGetMaxY(self.FileFrm.selfFrm);
}

@end
