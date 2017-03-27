#import "HCTaskViewFrame.h"

@implementation HCTaskViewFrame

-(void)setTask:(HCTask *)Task{
    
    _Task = Task;
    
    //任务标题Viewfrm
    // 计算 "任务标题" 尺寸size
    NSDictionary *TaskFormAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        TaskFormAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    }else{
        TaskFormAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    }
    CGSize TaskFormSize = [Task.taskform sizeWithAttributes:TaskFormAtt];
    CGFloat TaskFormX = HCStatusCellInset;
    CGFloat TaskFormY = HCStatusCellInset;
    self.TaskFormFrm = (CGRect){TaskFormX,TaskFormY,TaskFormSize};
    
    //任务标题View
    self.TaskTopViewFrm = (CGRect){0,0,UIScreenW - 40,CGRectGetMaxY(self.TaskFormFrm) + HCStatusCellInset};
    
    //分割线
    CGFloat HighlightViewAX = CGRectGetMaxX(self.TaskFormFrm) + 3;
    CGFloat HighlightViewAY = HCStatusCellInset;
    self.HighlightViewAFrm = (CGRect){HighlightViewAX,HighlightViewAY,1,20};
    
    //任务标题frm
    // 计算 "任务标题" 尺寸size
    NSDictionary *TaskNameAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        TaskNameAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    }else{
        TaskNameAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    }
    CGSize TaskNameSize = [Task.taskname sizeWithAttributes:TaskNameAtt];
    CGFloat TaskNameX = CGRectGetMaxX(self.HighlightViewAFrm) + 3;
    CGFloat TaskNameY = HCStatusCellInset;
    self.TaskNameFrm = (CGRect){TaskNameX,TaskNameY,TaskNameSize};
    
    //2.任务类型(字体大小14)
    // 计算 "任务类型" 尺寸size
    NSDictionary *TaskTypeAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        TaskTypeAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    }else{
        TaskTypeAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    }
    CGSize TaskTypeSize = [Task.tasktype sizeWithAttributes:TaskTypeAtt];
    CGFloat TaskTypeX = UIScreenW - 40 - TaskTypeSize.width - HCStatusCellInset;
    CGFloat TaskTypeY = HCStatusCellInset;
    self.TaskTypeFrm = (CGRect){TaskTypeX,TaskTypeY,TaskTypeSize};
    
//    //竖分割线
//    CGFloat HighlightViewBX = (UIScreenW- 40)/2;
//    CGFloat HighlightViewBY = CGRectGetMaxY(self.TaskUserNameFrm) + 5;
//    self.HighlightViewBFrm = (CGRect){HighlightViewBX,HighlightViewBY+3, 0.1 ,BuildTimeSize.height + 10};
    
    
    
    
    //2.任务发送者(字体大小14)
    // 计算 "任务发送者" 尺寸size
    NSDictionary *TaskUserNameatt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        TaskUserNameatt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        TaskUserNameatt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize TaskUserNameSize = [[[NSString alloc]initWithFormat:@"发布者：%@",Task.username] sizeWithAttributes:TaskUserNameatt];
    CGFloat TaskUserNameX = HCStatusCellInset;
    CGFloat TaskUserNameY = CGRectGetMaxY(self.TaskTopViewFrm) + HCStatusCellInset;
    if (Task.username != nil) {
        self.TaskUserNameFrm = (CGRect){TaskUserNameX,TaskUserNameY,TaskUserNameSize};
    }
    
    //任务状态frm
    // 计算 "任务状态" 尺寸size
    CGFloat TaskStateX = UIScreenW - 40 - 55 - HCStatusCellInset;
    CGFloat TaskStateY = CGRectGetMaxY(self.TaskTypeFrm) + HCStatusCellInset;
    self.TaskStateFrm = (CGRect){TaskStateX,TaskStateY,30,15};
    
    
    //用户任务执行状态(字体大小14)
    // 计算 "用户任务执行状态" 尺寸size
    CGFloat HoperaTionsX = UIScreenW - 40 - 55 - HCStatusCellInset;
    CGFloat HoperaTionsY = CGRectGetMaxY(self.TaskStateFrm) + HCStatusCellInset;
    self.HoperaTionsFrm = (CGRect){HoperaTionsX,HoperaTionsY,75,15};

#pragma mark 做到这里
    
//    //横分割线
//    CGFloat HighlightViewAX = HCStatusCellInset;
//    CGFloat HighlightViewAY = CGRectGetMaxY(self.TaskUserNameFrm) + 5;
//    self.HighlightViewAFrm = (CGRect){HighlightViewAX,HighlightViewAY,UIScreenW- 60,0.1};

    //任务发布时间(字体大小14)
    // 计算 "任务发布时间" 尺寸size
    NSDictionary *BuildTimeatt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        BuildTimeatt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        BuildTimeatt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize BuildTimeSize = [[[NSString alloc]initWithFormat:@"创建：%@",[Task.buildtime substringToIndex:17]] sizeWithAttributes:BuildTimeatt];
    CGFloat BuildTimeX = HCStatusCellInset;
    CGFloat BuildTimeY;
    if (Task.username != nil) {
        BuildTimeY = CGRectGetMaxY(self.TaskUserNameFrm) + HCStatusCellInset;
    }else{
        BuildTimeY = CGRectGetMaxY(self.TaskTopViewFrm) + HCStatusCellInset;
    }
    self.BuildTimeFrm = (CGRect){BuildTimeX,BuildTimeY,BuildTimeSize};
    
    //任务截止时间(字体大小14)
    // 计算 "任务截止时间" 尺寸size
    NSDictionary *DeadLineatt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        DeadLineatt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        DeadLineatt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize DeadLineSize = [[[NSString alloc]initWithFormat:@"截止：%@",[Task.deadlinetext substringToIndex:17]] sizeWithAttributes:DeadLineatt];
    CGFloat DeadLineX = HCStatusCellInset;
    CGFloat DeadLineY = CGRectGetMaxY(self.BuildTimeFrm) + HCStatusCellInset;
    self.DeadLineFrm = (CGRect){DeadLineX,DeadLineY,DeadLineSize};
    
    
    self.selfFrm = CGRectMake(20, 5, UIScreenW - 40, CGRectGetMaxY(self.DeadLineFrm) + HCStatusCellInset);
    
}

@end
