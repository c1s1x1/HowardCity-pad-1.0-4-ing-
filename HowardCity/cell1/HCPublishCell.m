#import "HCPublishCell.h"
#import "HCPublishView.h"

@interface HCPublishCell()

@property(nonatomic,weak)HCPublishView *PublishView;

@end

@implementation HCPublishCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //项目View
        HCPublishView *PublishView = [[HCPublishView alloc]init];
        
        PublishView.backgroundColor = [UIColor whiteColor];
        //给bgView边框设置阴影
        PublishView.layer.shadowOffset = CGSizeMake(1,1);
        PublishView.layer.shadowOpacity = 0.3;
        PublishView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self addSubview:PublishView];
        self.PublishView = PublishView;
        
    }
    return self;
}

+(instancetype)cellWithTabbleView:(UITableView *)tableView{
    static NSString *ID = @"StatusCell";
    
    HCPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HCPublishCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)setPublishCellFrm:(HCPublishCellFrame *)PublishCellFrm{
    _PublishCellFrm = PublishCellFrm;
    
    //设置detailView的Frm
    self.PublishView.PublishFrm = PublishCellFrm.PublishFrm;
    
}

@end
