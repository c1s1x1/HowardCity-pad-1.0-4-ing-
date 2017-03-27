#import "HCNoticeCell.h"
#import "HCNoticeView.h"

@interface HCNoticeCell()

@property(nonatomic,weak)HCNoticeView *NoticeView;

@end

@implementation HCNoticeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //项目View
        HCNoticeView *NoticeView = [[HCNoticeView alloc]init];
        
        NoticeView.backgroundColor = HCColor(255, 255, 255, 1);
        NoticeView.layer.cornerRadius = 10;
        //给bgView边框设置阴影
        NoticeView.layer.shadowOffset = CGSizeMake(1,1);
        NoticeView.layer.shadowOpacity = 0.3;
        NoticeView.layer.shadowColor = [UIColor blackColor].CGColor;
        [self addSubview:NoticeView];
        self.backgroundColor = HCColor(55, 106, 133, 1);
        self.NoticeView = NoticeView;
        
    }
    return self;
}

+(instancetype)cellWithTabbleView:(UITableView *)tableView{
    static NSString *ID = @"StatusCell";
    
    HCNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HCNoticeCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)setNoticeCellFrm:(HCNoticeCellFrame *)NoticeCellFrm{
    _NoticeCellFrm = NoticeCellFrm;
    
    //设置detailView的Frm
    self.NoticeView.NoticeFrm = NoticeCellFrm.NoticeFrm;
    
}

@end
