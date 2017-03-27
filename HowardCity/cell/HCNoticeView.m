#import "HCNoticeView.h"
#import "KSStringMatching.h"
#import "UIImageView+WebCache.h"

@interface HCNoticeView()

@property(nonatomic,weak) UILabel *NoticTitleLabel;//头像
@property(nonatomic,weak) UILabel *SenderLabel;//昵称
@property(nonatomic,weak) UILabel *SendTimeLabel;//昵称
@property(nonatomic,weak) UILabel *IsvisitLabel;//昵称
@property(nonatomic,weak) UILabel *InfoTypeLabel;//昵称
@end

@implementation HCNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        // 1.头像
        UILabel *NoticTitleLabel = [[UILabel alloc] init];
//        proNoticeImgView.layer.masksToBounds = YES;
//        proNoticeImgView.layer.cornerRadius = 20;
        [self addSubview:NoticTitleLabel];
        self.NoticTitleLabel = NoticTitleLabel;
        
        // 2.名称
        UILabel *SenderLabel = [[UILabel alloc] init];
        [self addSubview:SenderLabel];
        self.SenderLabel = SenderLabel;
        
        // 2.名称
        UILabel *SendTimeLabel = [[UILabel alloc] init];
        [self addSubview:SendTimeLabel];
        self.SendTimeLabel = SendTimeLabel;
        
        // 2.名称
        UILabel *IsvisitLabel = [[UILabel alloc] init];
        [self addSubview:IsvisitLabel];
        self.IsvisitLabel = IsvisitLabel;
        
        // 2.名称
        UILabel *InfoTypeLabel = [[UILabel alloc] init];
        [self addSubview:InfoTypeLabel];
        self.InfoTypeLabel = InfoTypeLabel;
    
    }
    
    return self;
}

-(void)setNoticeFrm:(HCNoticeViewFrame *)NoticeFrm{
    _NoticeFrm = NoticeFrm;
    
    HCNotice *Notice = NoticeFrm.Notice;
    
    // 设置自身frm
    self.frame = NoticeFrm.selfFrm;
    

    // 通知标题
    self.NoticTitleLabel.text = Notice.title;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.NoticTitleLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.NoticTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    self.NoticTitleLabel.frame = NoticeFrm.NoticTitleFrm;

    
    
    // 通知发送者
    self.SenderLabel.text = Notice.sender;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.SenderLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.SenderLabel.font = [UIFont systemFontOfSize:12];
    }
    self.SenderLabel.frame = NoticeFrm.SenderFrm;
    
    // 通知发送时间
    self.SendTimeLabel.text = Notice.sendTime;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.SendTimeLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.SendTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    self.SendTimeLabel.textColor = HCColor(0, 0, 0, 0.4);
    self.SendTimeLabel.frame = NoticeFrm.SendTimeFrm;
    
    // 通知状态
    if ([Notice.Isvisit isEqualToString:@"0"]) {
        self.IsvisitLabel.text = @"未读";
        self.IsvisitLabel.textColor = HCColor(208, 4, 15, 1);
    }else{
        self.IsvisitLabel.text = @"已读";
        self.IsvisitLabel.textColor = [UIColor grayColor];
    }
    
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.IsvisitLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.IsvisitLabel.font = [UIFont systemFontOfSize:12];
    }
    self.IsvisitLabel.frame = NoticeFrm.IsvisitLabelFrm;
    
    // 通知发送时间
    switch ([Notice.infoType intValue])
    {
        case 0:
            self.InfoTypeLabel.text = @"任务";
            self.InfoTypeLabel.textColor = HCColor(10, 148, 26, 1);
            break;
            
        case 1:
            self.InfoTypeLabel.text = @"普通";
            self.InfoTypeLabel.textColor = HCColor(13, 49, 205, 1);
            break;
            
        case 2:
            self.InfoTypeLabel.text = @"紧急";
            self.InfoTypeLabel.textColor = HCColor(208, 4, 15, 1);
            break;
    }
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.InfoTypeLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.InfoTypeLabel.font = [UIFont systemFontOfSize:12];
    }
    self.InfoTypeLabel.frame = NoticeFrm.InfoTypeLabelFrm;
}

@end
