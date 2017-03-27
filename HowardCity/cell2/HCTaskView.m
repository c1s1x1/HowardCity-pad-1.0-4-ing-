#import "HCTaskView.h"
#import "KSStringMatching.h"
#import "UIImageView+WebCache.h"
#import "TLTiltHighlightView.h"

@interface HCTaskView()

@property(nonatomic,weak) UIView *TaskTopView;
@property(nonatomic,weak) UILabel *TaskFormLabel;//任务状态
@property(nonatomic,weak) UILabel *TaskNameLabel;//任务名称
@property(nonatomic,weak) UILabel *TaskTypeLabel;//任务类型
@property(nonatomic,weak) UILabel *TaskUserNameLabel;//任务发布者
@property(nonatomic,weak) UILabel *TaskStateLabel;//任务状态
@property(nonatomic,weak) UILabel *HoperaTionsLabel;//用户任务执行状态
@property(nonatomic, weak) UIView *highlightViewA;//分割线
@property(nonatomic,weak) UILabel *BuildTimeLabel;//任务创建时间
@property(nonatomic, strong) TLTiltHighlightView *highlightViewB;//分割线
@property(nonatomic,weak) UILabel *DeadLineLabel;//任务截止时间
@end

@implementation HCTaskView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        //标题View
        UIView *TaskTopView = [[UIView alloc]init];
        TaskTopView.layer.cornerRadius = 10;
        TaskTopView.backgroundColor = HCColor(192, 164, 60, 1);
        [self addSubview:TaskTopView];
        self.TaskTopView = TaskTopView;
        
        //任务状态
        UILabel *TaskFormLabel = [[UILabel alloc] init];
        [self addSubview:TaskFormLabel];
        self.TaskFormLabel = TaskFormLabel;
        
        //任务名称
        UILabel *TaskNameLabel = [[UILabel alloc] init];
        [self addSubview:TaskNameLabel];
        self.TaskNameLabel = TaskNameLabel;
        
        //任务类型
        UILabel *TaskTypeLabel = [[UILabel alloc] init];
        [self addSubview:TaskTypeLabel];
        self.TaskTypeLabel = TaskTypeLabel;
        
        //任务状态
        UILabel *TaskStateLabel = [[UILabel alloc] init];
        [self addSubview:TaskStateLabel];
        self.TaskStateLabel = TaskStateLabel;
        
        //用户任务执行状态
        UILabel *HoperaTionsLabel = [[UILabel alloc] init];
        [self addSubview:HoperaTionsLabel];
        self.HoperaTionsLabel = HoperaTionsLabel;
        
        //任务发布者
        UILabel *TaskUserNameLabel = [[UILabel alloc] init];
        [self addSubview:TaskUserNameLabel];
        self.TaskUserNameLabel = TaskUserNameLabel;
        
        //横分割线
        UIView *highlightViewA = [[UIView alloc] init];
        highlightViewA.backgroundColor = [UIColor whiteColor];
        [self addSubview:highlightViewA];
        self.highlightViewA = highlightViewA;
        
        //任务创建时间
        UILabel *BuildTimeLabel = [[UILabel alloc] init];
        [self addSubview:BuildTimeLabel];
        self.BuildTimeLabel = BuildTimeLabel;
        
//        //竖分割线
//        TLTiltHighlightView *highlightViewB = [[TLTiltHighlightView alloc] init];
//        highlightViewB.highlightColor = [UIColor grayColor];
//        highlightViewB.backgroundColor = [UIColor clearColor];
//        highlightViewB.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
//        [self addSubview:highlightViewB];
//        self.highlightViewB = highlightViewB;
//        
        //任务截止时间
        UILabel *DeadLineLabel = [[UILabel alloc] init];
        [self addSubview:DeadLineLabel];
        self.DeadLineLabel = DeadLineLabel;
    
    }
    
    return self;
}

-(void)setTaskFrm:(HCTaskViewFrame *)TaskFrm{
    _TaskFrm = TaskFrm;
    
    HCTask *Task = TaskFrm.Task;
    
    // 设置自身frm
    self.frame = TaskFrm.selfFrm;
    
    //任务标题View
    self.TaskTopView.frame = TaskFrm.TaskTopViewFrm;
    
    // 任务标题
    self.TaskFormLabel.text = Task.taskform;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.TaskFormLabel.font = [UIFont systemFontOfSize:20];
    }else{
        self.TaskFormLabel.font = [UIFont systemFontOfSize:17];
    }
    self.TaskFormLabel.textColor = HCColor(255, 255, 255, 1);
    self.TaskFormLabel.frame = TaskFrm.TaskFormFrm;

    // 任务标题
    self.TaskNameLabel.text = Task.taskname;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.TaskNameLabel.font = [UIFont systemFontOfSize:20];
    }else{
        self.TaskNameLabel.font = [UIFont systemFontOfSize:17];
    }
    self.TaskNameLabel.textColor = HCColor(255, 255, 255, 1);
    self.TaskNameLabel.frame = TaskFrm.TaskNameFrm;
    
    // 任务类型
    self.TaskTypeLabel.text = Task.tasktype;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.TaskTypeLabel.font = [UIFont systemFontOfSize:20];
    }else{
        self.TaskTypeLabel.font = [UIFont systemFontOfSize:17];
    }
    self.TaskTypeLabel.textColor = HCColor(255, 255, 255, 1);
    self.TaskTypeLabel.frame = TaskFrm.TaskTypeFrm;
    
    // 任务发布者
    self.TaskUserNameLabel.text = [[NSString alloc]initWithFormat:@"发布者：%@",Task.username];;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.TaskUserNameLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.TaskUserNameLabel.font = [UIFont systemFontOfSize:12];
    }
    self.TaskUserNameLabel.frame = TaskFrm.TaskUserNameFrm;
    
    /**
     *  任务状态
     0-正常状态；
     1-失效状态；
     2-完成状态；(结束任务)
     */
    switch ([Task.taskstate intValue])
    {
        case 0:
            self.TaskStateLabel.text = @"正常";
            self.TaskStateLabel.textColor = HCColor(10, 148, 26, 1);
            break;
            
        case 1:
            self.TaskStateLabel.text = @"失效";
            self.TaskStateLabel.textColor = HCColor(13, 49, 205, 1);
            break;
            
        case 2:
            self.TaskStateLabel.text = @"完成";
            self.TaskStateLabel.textColor = HCColor(208, 4, 15, 1);
            break;
    }
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.TaskStateLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.TaskStateLabel.font = [UIFont systemFontOfSize:12];
    }
    self.TaskStateLabel.frame = TaskFrm.TaskStateFrm;
    
    /**
     *  用户任务执行状态
     0-未阅读
     1-已阅读
     2-等待审核
     3-审核通过
     4-审核不通过
     5-已过期限，过期
     */
    switch ([Task.hoperations intValue])
    {
        case 0:
            self.HoperaTionsLabel.text = @"未阅读";
            self.HoperaTionsLabel.textColor = HCColor(10, 148, 26, 1);
            break;
            
        case 1:
            self.HoperaTionsLabel.text = @"已阅读";
            self.HoperaTionsLabel.textColor = HCColor(13, 49, 205, 1);
            break;
            
        case 2:
            self.HoperaTionsLabel.text = @"等待审核";
            self.HoperaTionsLabel.textColor = HCColor(208, 4, 15, 1);
            break;
            
        case 3:
            self.HoperaTionsLabel.text = @"审核通过";
            self.HoperaTionsLabel.textColor = HCColor(208, 4, 15, 1);
            break;
            
        case 4:
            self.HoperaTionsLabel.text = @"审核不通过";
            self.HoperaTionsLabel.textColor = HCColor(208, 4, 15, 1);
            break;
            
        case 5:
            self.HoperaTionsLabel.text = @"过期";
            self.HoperaTionsLabel.textColor = HCColor(208, 4, 15, 1);
            break;
    }
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.HoperaTionsLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.HoperaTionsLabel.font = [UIFont systemFontOfSize:12];
    }
    self.HoperaTionsLabel.frame = TaskFrm.HoperaTionsFrm;
    
    //横分割线
    self.highlightViewA.frame = TaskFrm.HighlightViewAFrm;
//    self.highlightViewA.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    // 任务发送时间
    self.BuildTimeLabel.text = [[NSString alloc]initWithFormat:@"创建：%@",[Task.buildtime substringToIndex:16]];
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.BuildTimeLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.BuildTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    self.BuildTimeLabel.textColor = HCColor(0, 0, 0, 1);
    self.BuildTimeLabel.frame = TaskFrm.BuildTimeFrm;
    
    //竖分割线
    self.highlightViewB.frame = TaskFrm.HighlightViewBFrm;
//    self.highlightViewB.transform = CGAffineTransformMakeRotation(M_PI/2);

    // 任务发送时间
    self.DeadLineLabel.text = [[NSString alloc]initWithFormat:@"截止：%@",[Task.deadlinetext substringToIndex:16]];
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.DeadLineLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.DeadLineLabel.font = [UIFont systemFontOfSize:12];
    }
    self.DeadLineLabel.textColor = HCColor(0, 0, 0, 1);
    self.DeadLineLabel.frame = TaskFrm.DeadLineFrm;
}

@end
