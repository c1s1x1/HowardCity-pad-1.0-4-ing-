#import "HCTaskCell.h"
#import "HCTaskView.h"

@interface HCTaskCell()

@property(nonatomic,weak)HCTaskView *TaskView;

@end

@implementation HCTaskCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //项目View
        HCTaskView *TaskView = [[HCTaskView alloc]init];
        
        TaskView.backgroundColor = [UIColor whiteColor];
        TaskView.layer.cornerRadius = 10;
        //给bgView边框设置阴影
        TaskView.layer.shadowOffset = CGSizeMake(1,1);
        TaskView.layer.shadowOpacity = 0.3;
        TaskView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self addSubview:TaskView];
        self.backgroundColor = HCColor(55, 106, 133, 1);
        self.TaskView = TaskView;
        
    }
    return self;
}

+(instancetype)cellWithTabbleView:(UITableView *)tableView{
    static NSString *ID = @"StatusCell";
    
    HCTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HCTaskCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)setTaskCellFrm:(HCTaskCellFrame *)TaskCellFrm{
    _TaskCellFrm = TaskCellFrm;
    
    //设置detailView的Frm
    self.TaskView.TaskFrm = TaskCellFrm.TaskFrm;
    
}

@end
