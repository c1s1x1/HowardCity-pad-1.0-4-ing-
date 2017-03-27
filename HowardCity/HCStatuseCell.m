#import "HCStatuseCell.h"
#import "HCStatuseOriginalView.h"

@interface HCStatuseCell()

@property(nonatomic,weak)HCStatuseOriginalView *originalView;

@end

@implementation HCStatuseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //项目View
        HCStatuseOriginalView *OriginalView = [[HCStatuseOriginalView alloc]init];
        
//        OriginalView.layer.masksToBounds = YES;
        OriginalView.layer.cornerRadius = 20;
        
        OriginalView.backgroundColor = [UIColor whiteColor];
//        //给bgView边框设置阴影
//        OriginalView.layer.shadowOffset = CGSizeMake(1,1);
//        OriginalView.layer.shadowOpacity = 0.3;
//        OriginalView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        OriginalView.layer.shadowOpacity = 1;// 阴影透明度
        OriginalView.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
        OriginalView.layer.shadowRadius = 10;// 阴影扩散的范围控制
        OriginalView.layer.shadowOffset = CGSizeMake(5, 5);// 阴影的范围
//        OriginalView.layer.borderColor = [UIColor blackColor].CGColor;//边框颜色
//        OriginalView.layer.borderWidth = 2;//边框宽度
        [self.contentView addSubview:OriginalView];
        self.contentView.backgroundColor = HCColor(55, 106, 133, 1);
         self.originalView = OriginalView;
        
    }
    return self;
}

+(instancetype)cellWithTabbleView:(UITableView *)tableView{
    static NSString *ID = @"StatusCell";
    
    HCStatuseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HCStatuseCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)setStatusCellFrm:(HCStatuseCellFrame *)statusCellFrm{
    _statusCellFrm = statusCellFrm;
    
    //设置detailView的Frm
    self.originalView.originalFrm = statusCellFrm.originalFrm;
    
}

@end
