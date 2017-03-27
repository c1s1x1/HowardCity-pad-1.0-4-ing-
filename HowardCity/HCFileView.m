#import "HCFileView.h"
#import "KSStringMatching.h"
#import "UIImageView+WebCache.h"

@interface HCFileView()

@property(nonatomic,weak) UIImageView *profileImgView;//头像
@property(nonatomic,weak) UILabel *screenNameLabel;//昵称
@property(nonatomic,weak) UILabel *createTimeLabel;//昵称
@end

@implementation HCFileView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        // 1.头像
        UIImageView *profileImgView = [[UIImageView alloc] init];
//        profileImgView.layer.masksToBounds = YES;
//        profileImgView.layer.cornerRadius = 20;
        [self addSubview:profileImgView];
        self.profileImgView = profileImgView;
        
        // 2.名称
        UILabel *screenNameLabel = [[UILabel alloc] init];
        [self addSubview:screenNameLabel];
        self.screenNameLabel = screenNameLabel;
        
        // 2.名称
        UILabel *createTimeLabel = [[UILabel alloc] init];
        [self addSubview:createTimeLabel];
        self.createTimeLabel = createTimeLabel;
    
    }
    
    return self;
}

-(void)setFileFrm:(HCFileViewFrame *)FileFrm{
    _FileFrm = FileFrm;
    
    HCFilerecord *Filerecord = FileFrm.Filerecord;
    
    // 设置自身frm
    self.frame = FileFrm.selfFrm;
    
    // 设置项目图片
    self.profileImgView.frame = FileFrm.profileFrm;
    if ([Filerecord.filetype isEqualToString:@"folder"]){
        self.profileImgView.image = [UIImage imageNamed:@"folder"];
    }else{
        NSRange lastSymbol = [Filerecord.filename rangeOfString:@"." options:NSBackwardsSearch];
        NSUInteger location = lastSymbol.location + 1;
        NSString *kind = [Filerecord.filename substringFromIndex:location];
        if ([kind isEqualToString:@"jpg"]||[kind isEqualToString:@"png"]||[kind isEqualToString:@"bmp"]||[kind isEqualToString:@"gif"]) {
            [self.profileImgView sd_setImageWithURL:Filerecord.thumbnailPath placeholderImage:[UIImage imageNamed:[kind lowercaseString]]];
        }else{
            UIImage *image= [UIImage imageNamed:[kind lowercaseString]];
            if (image) {
                self.profileImgView.image = image;
            }else{
                self.profileImgView.image = [UIImage imageNamed:@"other"];
            }
            
        }
        
    };
    
    
    // 显示名称
    self.screenNameLabel.text =Filerecord.filename;
    if ( Filerecord.filename.length >19) {
        self.screenNameLabel.text =[[NSString alloc]initWithFormat:@"%@...",[ Filerecord.filename substringToIndex:16]];
    }
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.screenNameLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.screenNameLabel.font = [UIFont systemFontOfSize:12];
    }
    self.screenNameLabel.frame = FileFrm.screenNameFrm;
    
    // 显示名称
    self.createTimeLabel.text = Filerecord.createTime;
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        self.createTimeLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.createTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    self.createTimeLabel.textColor = HCColor(0, 0, 0, 0.4);
    self.createTimeLabel.frame = FileFrm.CreateTimeFrm;
}

@end
