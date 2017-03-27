#import "HCStatuseOriginalView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "HCUserInfo.h"
#import "LXGradientProcessView.h"
#import "UIImageView+WebCache.h"
#import "TLTiltHighlightView.h"

@interface HCStatuseOriginalView()

@property(nonatomic,weak) UIImageView *profileImgView;//头像
@property(nonatomic,weak) UILabel *screenNameLabel;//昵称
@property(nonatomic,weak) UILabel *PersonAndSpaceLabel;//人数和空间
@property(nonatomic,weak) UILabel *SPILabel;//SPI昵称
@property(nonatomic,weak) UILabel *CPILabel;//CPI昵称
@property(nonatomic,weak) UILabel *SVLabel;//SV昵称
@property(nonatomic,weak) UILabel *CVLabel;//CV昵称
@property (nonatomic, strong) LXGradientProcessView *SPI;
@property (nonatomic, strong) LXGradientProcessView *CPI;
@property (nonatomic, strong) LXGradientProcessView *SV;
@property (nonatomic, strong) LXGradientProcessView *CV;
@property(nonatomic,weak) UILabel *InformationLabel;//项目描述
@property(nonatomic,weak) UILabel *UserNameLabel;//创建者
@property(nonatomic,weak) UILabel *BuildTimeLabel;//创建时间
@property (nonatomic, strong) TLTiltHighlightView *highlightView;//分割线
@end

@implementation HCStatuseOriginalView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        // 1.头像
        UIImageView *profileImgView = [[UIImageView alloc] init];
        profileImgView.layer.masksToBounds = YES;
        profileImgView.layer.cornerRadius = 20;
        [self addSubview:profileImgView];
        self.profileImgView = profileImgView;
        
        // 2.名称
        UILabel *screenNameLabel = [[UILabel alloc] init];
        [self addSubview:screenNameLabel];
        self.screenNameLabel = screenNameLabel;
        
        // 2.名称
        UILabel *PersonAndSpaceLabel = [[UILabel alloc] init];
        [self addSubview:PersonAndSpaceLabel];
        self.PersonAndSpaceLabel = PersonAndSpaceLabel;
        
        TLTiltHighlightView *highlightView = [[TLTiltHighlightView alloc] init];
        highlightView.highlightColor = [UIColor blackColor];
        highlightView.backgroundColor = [UIColor clearColor];
        highlightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:highlightView];
        self.highlightView = highlightView;
        
        // 2.项目详情
        UILabel *InformationLabel = [[UILabel alloc] init];
        [self addSubview:InformationLabel];
        self.InformationLabel = InformationLabel;
        
        if(UI_IS_IPHONE){
#pragma mark -  手机无横竖屏
            // 3.SPI
            UILabel *SPILabel = [[UILabel alloc] init];
            [self addSubview:SPILabel];
            self.SPILabel = SPILabel;
            
            // 渐变进度条
            LXGradientProcessView *SPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            [self addSubview:SPIprogressView];
            self.SPI = SPIprogressView;
            
            // 4.CPI
            UILabel *CPILabel = [[UILabel alloc] init];
            [self addSubview:CPILabel];
            self.CPILabel = CPILabel;
            
            // 渐变进度条
            LXGradientProcessView *CPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            [self addSubview:CPIprogressView];
            self.CPI = CPIprogressView;
            
        }else if (!(UIScreenW >= 1024)) {
#pragma mark -  平板
            // 3.SPI
            //名称
            UILabel *SPILabel = [[UILabel alloc] init];
            [self addSubview:SPILabel];
            self.SPILabel = SPILabel;
            // 渐变进度条
            LXGradientProcessView *SPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
            [self addSubview:SPIprogressView];
            self.SPI = SPIprogressView;
            
            // 4.CPI
            //名称
            UILabel *CPILabel = [[UILabel alloc] init];
            [self addSubview:CPILabel];
            self.CPILabel = CPILabel;
            
            // 渐变进度条
            LXGradientProcessView *CPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
            [self addSubview:CPIprogressView];
            self.CPI = CPIprogressView;
        }else{
#pragma mark -  3. 实现数据源（代理）方法
            // 3.SPI
            UILabel *SPILabel = [[UILabel alloc] init];
            [self addSubview:SPILabel];
            self.SPILabel = SPILabel;
            
            // 渐变进度条
            LXGradientProcessView *SPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
            [self addSubview:SPIprogressView];
            self.SPI = SPIprogressView;
            
            // 4.CPI
            UILabel *CPILabel = [[UILabel alloc] init];
            [self addSubview:CPILabel];
            self.CPILabel = CPILabel;
            
            // 渐变进度条
            LXGradientProcessView *CPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
            [self addSubview:CPIprogressView];
            self.CPI = CPIprogressView;
        }
        
        // 2.创建者
        UILabel *UserNameLabel = [[UILabel alloc] init];
        [self addSubview:UserNameLabel];
        self.UserNameLabel = UserNameLabel;
        
        // 2.创建时间
        UILabel *BuildTimeLabel = [[UILabel alloc] init];
        [self addSubview:BuildTimeLabel];
        self.BuildTimeLabel = BuildTimeLabel;
    
    }
    
    return self;
}

-(void)setOriginalFrm:(HCStatuseOriginalCellFrame *)originalFrm{
    _originalFrm = originalFrm;
    
    HCStatuses *statuse = originalFrm.statuse;
    
    // 设置自身frm
    self.frame = originalFrm.selfFrm;
    
    // 设置项目图片
    self.profileImgView.frame = originalFrm.profileFrm;
    [self.profileImgView sd_setImageWithURL:statuse.projectImgPath placeholderImage:[UIImage imageNamed:@"home_back"]];
    
    if (!UI_IS_IPHONE) {
        // 显示名称
        self.screenNameLabel.font = HCStatusOriginalSNFont;
        self.PersonAndSpaceLabel.font =HCStatusOriginalSNFont;
        self.SPILabel.font = HCStatusOriginalSNFont;
        self.CPILabel.font = HCStatusOriginalSNFont;
        self.InformationLabel.font = HCStatusOriginalSNFont;
    }else{
        self.screenNameLabel.font = [UIFont systemFontOfSize:15];
        self.PersonAndSpaceLabel.font =[UIFont systemFontOfSize:10];
        self.SPILabel.font = [UIFont systemFontOfSize:10];
        self.CPILabel.font = [UIFont systemFontOfSize:10];
        self.InformationLabel.font = [UIFont systemFontOfSize:10];
    }
    // 显示名称
    int space;
    space = 100;
    if (statuse.occupation != 0) {
        space = (statuse.occupation/statuse.space)*100;
    }
    self.screenNameLabel.text = [[NSString alloc]initWithFormat:@"%@",statuse.projectname];
    self.screenNameLabel.frame = originalFrm.screenNameFrm;
    
    self.PersonAndSpaceLabel.text = [[NSString alloc]initWithFormat:@"项目现有%ld人  剩余%d%%空间",(long)statuse.peoplesum,space];
    self.PersonAndSpaceLabel.frame = originalFrm.PersonAndSpaceLabelFrm;
    
    self.highlightView.frame = originalFrm.HighLightFrm;
    
    // 显示项目详情
    self.InformationLabel.numberOfLines = 3;
    self.InformationLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.InformationLabel.textAlignment = NSTextAlignmentCenter;//文字居中
    self.InformationLabel.text = statuse.information;//最多60个字
    self.InformationLabel.frame = originalFrm.InformationFrm;
    
    // SPI显示进度
    self.SPILabel.text = @"SPI:";
    if (statuse.spi == 0) {
        self.SPI.percent = 50;
    }else{
        self.SPI.percent = statuse.spi/ 2 * 100;
    };
    self.SPILabel.frame = originalFrm.SPILableFrm;
    self.SPI.frame = originalFrm.SPIFrm;
    
    // CPI显示进度
    self.CPILabel.text = @"CPI:";
    if (statuse.cpi == 0) {
        self.CPI.percent = 50;
    }else{
        self.CPI.percent = statuse.cpi/ 2 * 100;
    };
    self.CPILabel.frame = originalFrm.CPILableFrm;
    self.CPI.frame = originalFrm.CPIFrm;
    
    // 创建者
    self.UserNameLabel.text = statuse.username;
    self.UserNameLabel.font = [UIFont systemFontOfSize:10];
    self.UserNameLabel.frame = originalFrm.UserNameFrm;
    
    // 创建时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.BuildTimeLabel.text = statuse.buildtime;
    self.BuildTimeLabel.font = [UIFont systemFontOfSize:10];
    self.BuildTimeLabel.frame = originalFrm.BuildTimeFrm;
    
}


@end
