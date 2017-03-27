//
//  LeftViewController.m
//  ThreeViewsText
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 杨鹤. All rights reserved.
//

#import "LeftViewController.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "AFNetworking.h"
#import "HCUserInfo.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "HCLoginViewController.h"
#import "UIImageView+WebCache.h"

@interface LeftViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) HCUserInfo *UserInfo;

@property(nonatomic,strong)HCAccount *account;

@property (nonatomic, assign) CGFloat UX;
@property (nonatomic, assign) CGFloat UY;
@property (nonatomic, assign) int font;

@property (weak, nonatomic) IBOutlet UIButton *exit;

@end

// 账号的存储路径
#define HCAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation LeftViewController

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置当前页面view的透明度
    self.view.alpha = 1;
    
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        //设置自动布局
        self.font = 20;
    }else{
        //设置自动布局
        self.font = 15;
    }
    
    //获取个人信息数据
    [self getHCUserInfo];
    
    // Do any additional setup after loading the view.
}


/**
 *  创建控件, 添加约束
 */
- (void)addConstraint {
    
    // 头像图片
    //创建图片框架，并设置背景图片为home_back
    UIImageView *headImage = [[UIImageView alloc] init];
    [headImage sd_setImageWithURL:self.UserInfo.imgpath placeholderImage:[UIImage imageNamed:@"home_back"]];
    //设置圆角
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 45;
    //设置不绝对布局
//    headImage.translatesAutoresizingMaskIntoConstraints = NO;
    //设置X/Y/W/H
    headImage.frame = CGRectMake(80, 80, 90, 90);
    //添加到当前页面
    [self.view addSubview:headImage];
    
    
    //创建文字框Label框架
    UILabel *UName = [[UILabel alloc]init];
    //设置用户名
    UName.text = self.UserInfo.username;
    UName.font = [UIFont systemFontOfSize:self.font];
    //设置字体颜色
    UName.textColor = [UIColor whiteColor];
    //设置字体居左
    UName.textAlignment = NSTextAlignmentLeft;
//    UName.translatesAutoresizingMaskIntoConstraints = NO;
    //设置不限制行数
    UName.numberOfLines = 0;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.font],};
    CGSize textSize = [UName.text boundingRectWithSize:CGSizeMake(800, 800) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    self.UX = headImage.x + ( headImage.w * 0.5 ) - (textSize.width * 0.5);
    self.UY = CGRectGetMaxY(headImage.frame) + HCStatusCellInset + 10;
    //设置X/Y/W/H
    UName.frame = (CGRect){self.UX,self.UY,textSize.width,textSize.height};
    //添加到当前页面
    [self.view addSubview:UName];
    
    
    //同上
    
    UILabel *USex = [self setUILabelWithHeadLabel:UName WithName:[[NSString alloc]initWithFormat:@"性别：%@",[self userInFoIsNULL:self.UserInfo.sex]]];
    USex.x = UName.x - 60 ;
    USex.y = UName.y + 100;
    [self.view addSubview:USex];
    
    //同上
    UILabel *UQQ = [self setUILabelWithHeadLabel:USex WithName:[[NSString alloc]initWithFormat:@"QQ：%@",[self userInFoIsNULL:self.UserInfo.qq]]];
    [self.view addSubview:UQQ];
    
    //同上
    UILabel *UTitle = [self setUILabelWithHeadLabel:UQQ WithName:[[NSString alloc]initWithFormat:@"公司职位：%@",[self userInFoIsNULL:self.UserInfo.title]]];
    [self.view addSubview:UTitle];
    
    //同上
    UILabel *UPhone = [self setUILabelWithHeadLabel:UTitle WithName:[[NSString alloc]initWithFormat:@"电话：%@",[self userInFoIsNULL:self.UserInfo.telephone]]];
    [self.view addSubview:UPhone];
    
    //同上
    UILabel *UWehar = [self setUILabelWithHeadLabel:UPhone WithName:[[NSString alloc]initWithFormat:@"微信：%@",[self userInFoIsNULL:self.UserInfo.wechat]]];
    [self.view addSubview:UWehar];
    
    //同上
    UILabel *UEmail = [self setUILabelWithHeadLabel:UWehar WithName:[[NSString alloc]initWithFormat:@"Email：%@",[self userInFoIsNULL:self.UserInfo.email]]];
    [self.view addSubview:UEmail];
    
    //同上
    UILabel *UCompany = [self setUILabelWithHeadLabel:UEmail WithName:[[NSString alloc]initWithFormat:@"公司：%@",[self userInFoIsNULL:self.UserInfo.company]]];
    [self.view addSubview:UCompany];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
        exit.frame = CGRectMake(70, 850, 120, 35);
    }else{
        exit.frame = CGRectMake(50, 590, 120, 35);
    }
    //设置圆角
    exit.layer.masksToBounds = YES;
    exit.layer.cornerRadius = 15;
    exit.tintColor = [UIColor whiteColor];
    exit.backgroundColor = [UIColor colorWithRed:12/255.0 green:54/255.0 blue:90/255.0 alpha:1.0];
    [exit setTitle:@"注销" forState:UIControlStateNormal];
    self.exit = exit;
    [self.exit addTarget:self action:@selector(Exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exit];
}

-(void)Exit{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:HCAccountPath]) {
        [defaultManager removeItemAtPath:HCAccountPath error:nil];
#pragma mark 拼接url
        NSString *ExitUrl = [[NSString alloc]initWithFormat:@"%@action=exit&access_token=%@",HCInterfacePrefix,self.account.access_token];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
#pragma mark 判断返回参数
        [manager GET:ExitUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[[responseObject objectForKey:@"result"]stringValue] isEqualToString:@"0"]) {
                HCLoginViewController *LoginView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
                
                self.view.window.rootViewController = LoginView;
                
                [self.view.window makeKeyAndVisible];

            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Set the text mode to show only text.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"注销失败，请稍后重试", @"HUD message title");
                [hud hideAnimated:YES afterDelay:1.f];
                self.view.userInteractionEnabled = YES;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"网络问题，请稍后重试", @"HUD message title");
            HCLog(@"%@",error);
            [hud hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled = YES;
        }];
        
    }
    
}

-(NSString *)userInFoIsNULL:(NSString *)userInFo{
    
    if ([userInFo isEqualToString:@"0"]) {
        userInFo = @"男";
    }else if ([userInFo isEqualToString:@"1"]) {
        userInFo = @"女";
    }else if ([userInFo isEqualToString:@""]){
        userInFo = @"尚未填写";
    }
    
    return userInFo;
}

-(UILabel *)setUILabelWithHeadLabel: (UILabel *)HeadLabel WithName: (NSString *)Info{
    UILabel *ULabel = [[UILabel alloc]init];
    
    ULabel.text = Info;
    
    ULabel.font = [UIFont systemFontOfSize:self.font];
    
    ULabel.textColor = [UIColor whiteColor];
    
    ULabel.textAlignment = NSTextAlignmentCenter;
    
//    ULabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    ULabel.numberOfLines = 0;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.font],};
    CGSize textSize = [ULabel.text boundingRectWithSize:CGSizeMake(200, 800) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;;
    //    //2.项目名称(字体大小14)
    self.UX = HeadLabel.x;
    self.UY = HeadLabel.y + HCUserInfoInset + 10;
    
    ULabel.frame = (CGRect){self.UX,self.UY,textSize.width,textSize.height};
    
    return ULabel;
}

-(void)getHCUserInfo{
    //获取user类
//    HCAccount *user = [HCAuthTool user];
    
    //拼接url
    NSString *InfoUrl = [[NSString alloc]initWithFormat:@"%@action=getUserInfo&access_token=%@",HCInterfacePrefix,self.account.access_token];
    
    //创建manage
#pragma mark 拼接url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
#pragma mark 判断返回参数
    //获取项目数据
    [manager GET:InfoUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //把字典放入模型里
        self.UserInfo = [HCUserInfo objectWithKeyValues:responseObject];
        
        //设置内容
        [self addConstraint];
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"请求失败%@",error);
    }];
}

#pragma mark 监听屏幕的旋转 ，ios8以前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    HCLog(@"侧边屏幕转了");
    if (UIScreenW >= 1024) {
        self.exit.y = 700;
    }else{
        self.exit.y = 850;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
