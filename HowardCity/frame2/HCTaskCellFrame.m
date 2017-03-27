#import "HCTaskCellFrame.h"

@implementation HCTaskCellFrame

-(void)setTask:(HCTask *)Task{
    _Task = Task;
    
    //给detialFrm设值
    HCTaskViewFrame *TaskFrm = [[HCTaskViewFrame alloc] init];
    TaskFrm.Task = Task;
    self.TaskFrm = TaskFrm;
    
    //给toolBar 设置值
    CGFloat toolbarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(TaskFrm.selfFrm);
    self.toolBarFrm = CGRectMake(toolbarX, toolBarY, UIScreenW, 10);
}

-(CGFloat)cellHeight{
    return CGRectGetMaxY(self.toolBarFrm);
}
 
@end
