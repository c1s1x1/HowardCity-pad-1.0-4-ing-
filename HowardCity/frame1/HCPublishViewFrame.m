#import "HCPublishViewFrame.h"

@implementation HCPublishViewFrame

-(void)setTask:(HCTask *)Task{
    
    _Task = Task;
    
    //通知标题frm
    // 计算 "通知标题" 尺寸size
    NSDictionary *TaskNameAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        TaskNameAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        TaskNameAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize TaskNameSize = [Task.taskname sizeWithAttributes:TaskNameAtt];
    CGFloat TaskNameX = HCStatusCellInset;
    CGFloat TaskNameY = HCStatusCellInset;
    self.TaskNameFrm = (CGRect){TaskNameX,TaskNameY,TaskNameSize};
    
    
    //2.通知类型(字体大小14)
    // 计算 "通知类型" 尺寸size
    NSDictionary *TaskTypeAtt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        TaskTypeAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        TaskTypeAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize TaskTypeSize = [Task.tasktype sizeWithAttributes:TaskTypeAtt];
    CGFloat TaskTypeX = HCStatusCellInset;
    CGFloat TaskTypeY = CGRectGetMaxY(self.TaskNameFrm) + 5;
    self.TaskTypeFrm = (CGRect){TaskTypeX,TaskTypeY,TaskTypeSize};
    
    //2.通知发送时间(字体大小14)
    // 计算 "通知发送时间" 尺寸size
    NSDictionary *BuildTimeatt;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        BuildTimeatt = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    }else{
        BuildTimeatt = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    }
    CGSize BuildTimeSize = [Task.buildtime sizeWithAttributes:BuildTimeatt];
    CGFloat BuildTimeX = UIScreenW- 40 -BuildTimeSize.width - HCStatusCellInset;
    CGFloat BuildTimeY = (CGRectGetMaxY(self.TaskNameFrm) + HCStatusCellInset)/2 + BuildTimeSize.height/2 + 5;
    self.BuildTimeFrm = (CGRect){BuildTimeX,BuildTimeY,BuildTimeSize};
    
    //通知状态frm
    // 计算 "通知状态" 尺寸size
    CGFloat TaskStateX = UIScreenW - 100 - HCStatusCellInset;
    CGFloat TaskStateY = CGRectGetMinY(self.TaskNameFrm);
    self.TaskStateFrm = (CGRect){TaskStateX,TaskStateY,28,15};
    
    
    self.selfFrm = CGRectMake(20, 5, UIScreenW - 40, CGRectGetMaxY(self.TaskTypeFrm) + HCStatusCellInset);
    
}

@end
