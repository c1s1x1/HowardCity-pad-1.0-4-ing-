#import "HCPublishView.h"
#import "KSStringMatching.h"
#import "UIImageView+WebCache.h"

@interface HCPublishView()

//@property(nonatomic,weak) UILabel *TaskNameLabel;//任务名称
//@property(nonatomic,weak) UILabel *TaskTypeLabel;//任务类型
//@property(nonatomic,weak) UILabel *TaskUserNameLabel;//任务发布者
//@property(nonatomic,weak) UILabel *TaskStateLabel;//任务状态
//@property(nonatomic,weak) UILabel *HoperaTionsLabel;//用户任务执行状态
//@property (nonatomic, strong) TLTiltHighlightView *highlightViewA;//分割线
//@property(nonatomic,weak) UILabel *BuildTimeLabel;//任务创建时间
//@property (nonatomic, strong) TLTiltHighlightView *highlightViewB;//分割线
//@property(nonatomic,weak) UILabel *DeadLineLabel;//任务截止时间
@end

@implementation HCPublishView

//-(instancetype)initWithFrame:(CGRect)frame{
//    
//    if(self = [super initWithFrame:frame]){
//        
//        // 1.头像
//        UILabel *TaskNameLabel = [[UILabel alloc] init];
////        proPublishImgView.layer.masksToBounds = YES;
////        proPublishImgView.layer.cornerRadius = 20;
//        [self addSubview:TaskNameLabel];
//        self.TaskNameLabel = TaskNameLabel;
//        
//        // 2.名称
//        UILabel *TaskTypeLabel = [[UILabel alloc] init];
//        [self addSubview:TaskTypeLabel];
//        self.TaskTypeLabel = TaskTypeLabel;
//        
//        // 2.名称
//        UILabel *BuildTimeLabel = [[UILabel alloc] init];
//        [self addSubview:BuildTimeLabel];
//        self.BuildTimeLabel = BuildTimeLabel;
//        
//        // 2.名称
//        UILabel *TaskStateLabel = [[UILabel alloc] init];
//        [self addSubview:TaskStateLabel];
//        self.TaskStateLabel = TaskStateLabel;
//    
//    }
//    
//    return self;
//}
//
//-(void)setPublishFrm:(HCPublishViewFrame *)PublishFrm{
//    _PublishFrm = PublishFrm;
//    
//    HCTask *Task = PublishFrm.Task;
//    
//    // 设置自身frm
//    self.frame = PublishFrm.selfFrm;
//    
//
//    // 通知标题
//    self.TaskNameLabel.text = Task.taskname;
//    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
//        self.TaskNameLabel.font = [UIFont systemFontOfSize:15];
//    }else{
//        self.TaskNameLabel.font = [UIFont systemFontOfSize:12];
//    }
//    self.TaskNameLabel.frame = PublishFrm.TaskNameFrm;
//
//    
//    
//    // 通知发送者
//    self.TaskTypeLabel.text = Task.tasktype;
//    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
//        self.TaskTypeLabel.font = [UIFont systemFontOfSize:15];
//    }else{
//        self.TaskTypeLabel.font = [UIFont systemFontOfSize:12];
//    }
//    self.TaskTypeLabel.frame = PublishFrm.TaskTypeFrm;
//    
//    // 通知发送时间
//    self.BuildTimeLabel.text = Task.buildtime;
//    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
//        self.BuildTimeLabel.font = [UIFont systemFontOfSize:15];
//    }else{
//        self.BuildTimeLabel.font = [UIFont systemFontOfSize:12];
//    }
//    self.BuildTimeLabel.textColor = HCColor(0, 0, 0, 0.4);
//    self.BuildTimeLabel.frame = PublishFrm.BuildTimeFrm;
//    
//    /**
//     *  任务状态
//     0-正常状态；
//     1-失效状态；
//     2-完成状态；(结束任务)
//     */
//    switch ([Task.taskstate intValue])
//    {
//        case 0:
//            self.TaskStateLabel.text = @"正常";
//            self.TaskStateLabel.textColor = HCColor(10, 148, 26, 1);
//            break;
//            
//        case 1:
//            self.TaskStateLabel.text = @"失效";
//            self.TaskStateLabel.textColor = HCColor(13, 49, 205, 1);
//            break;
//            
//        case 2:
//            self.TaskStateLabel.text = @"完成";
//            self.TaskStateLabel.textColor = HCColor(208, 4, 15, 1);
//            break;
//    }
//    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
//        self.TaskStateLabel.font = [UIFont systemFontOfSize:15];
//    }else{
//        self.TaskStateLabel.font = [UIFont systemFontOfSize:12];
//    }
//    self.TaskStateLabel.frame = PublishFrm.TaskStateFrm;
//}

@end
