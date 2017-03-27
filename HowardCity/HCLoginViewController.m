//
//  HCLoginViewController.h
//  HowardCity
//
//  Created by 紫月 on 16/4/15.
//  Copyright (c) 2016年 CSX. All rights reserved.
//
#import "HCLoginViewController.h"
#import "AFNetworking.h"
#import "HCAccount.h"
#import "HCAuthTool.h"
#import "RootViewController.h"
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "MBProgressHUD.h"
#import "CYLTabBarControllerConfig.h"
#import "CYLPlusButtonSubclass.h"

@interface HCLoginViewController ()
{
    BOOL _isAgain;
}
@property (weak, nonatomic) IBOutlet UITextField             *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField             *pwdTextField;
- (IBAction)loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicatorView;

@end

@implementation HCLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isAgain = NO;
    self.nameTextField.delegate = self;
    self.nameTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
//    self.pwdTextField.keyboardType = UIKeyboardTypePhonePad;
    self.pwdTextField.delegate = self;
    
//    AppDelegate
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
    
//    [self setNewOrientation:YES];//调用转屏代码
}

- (IBAction)loginButton {
    self.view.userInteractionEnabled = NO;
    
#pragma mark 用户名和密码
    NSString *LoginName     = self.nameTextField.text;
    NSString *LoginPassward = self.pwdTextField.text;
    if (([LoginName isEqualToString:@"UserName"]) || ([LoginPassward isEqualToString:@"请输入密码"])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请正确填写用户名和密码", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, UIScreenH - 200);
        
        [hud hideAnimated:YES afterDelay:3.f];
        self.view.userInteractionEnabled = YES;
        return ;
    }
    
    #pragma mark 等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"连接壕城云...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Indeterminate mode
        sleep(2);
        // Switch to determinate mode
#pragma mark 拼接url
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=login&email=%@&password=%@",HCInterfacePrefix,LoginName,LoginPassward];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
#pragma mark 判断返回参数
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[[responseObject objectForKey:@"result"]stringValue] isEqualToString:@"0"]) {
                //创建用户字典
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"username"]         = self.nameTextField.text;
                dic[@"userpassword"]     = self.pwdTextField.text;
                dic[@"created_time"]     = [NSDate date];
                dic[@"expires_in"]       = [responseObject objectForKey:@"expires_in"];
                dic[@"access_token"]       = [responseObject objectForKey:@"access_token"];
                //保存用户数据
                HCAccount *account       = [HCAccount accountWithDict:dic];
                [HCAuthTool SaveAccount:account];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    [self enterMain];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Set the text mode to show only text.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"账号或者密码错误，请重新输入", @"HUD message title");
                [hud hideAnimated:YES afterDelay:3.f];
                self.view.userInteractionEnabled = YES;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"网络问题，请稍后重试", @"HUD message title");
            HCLog(@"%@",error);
            [hud hideAnimated:YES afterDelay:3.f];
            self.view.userInteractionEnabled = YES;
        }];
    });
}

#pragma mark 设置首页
-(void)enterMain{
    dispatch_async(dispatch_get_main_queue(), ^{
    [CYLPlusButtonSubclass registerPlusButton];
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    self.view.window.rootViewController = tabBarControllerConfig.tabBarController;
    });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    if ([textField.placeholder isEqualToString:@"username"]) {
        HCLog(@"用户名点击了");
        if (_isAgain) {
            textField.clearsOnBeginEditing= NO;
        }
        _isAgain = YES;
    };
    
    return YES;
}

#pragma mark 键盘处理
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

@end
