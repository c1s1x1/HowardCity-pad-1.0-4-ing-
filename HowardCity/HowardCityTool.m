//
//  HowardCityTool.m
//  HowardCity
//
//  Created by CSX on 2016/11/15.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import "HowardCityTool.h"
#import "MBProgressHUD.h"
#import "HCLoginViewController.h"
#import "HCAuthTool.h"

// 账号的存储路径
#define HCAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation HowardCityTool

+(BOOL)TimeOut:(UIViewController *)ViewController{
     if (![HCAuthTool IsLogin]) {
         NSFileManager *defaultManager = [NSFileManager defaultManager];
         if ([defaultManager isDeletableFileAtPath:HCAccountPath]) {
             [defaultManager removeItemAtPath:HCAccountPath error:nil];
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:ViewController.view animated:YES];
             
             // Set the text mode to show only text.
             hud.mode = MBProgressHUDModeText;
             hud.label.text = NSLocalizedString(@"太久未登录，请重新登录", @"HUD message title");
             [hud showAnimated:YES whileExecutingBlock:^{
                 sleep(2);
             } completionBlock:^{
                 [hud removeFromSuperview];
                 HCLoginViewController *LoginView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
                 
                 ViewController.view.window.rootViewController = LoginView;
                 
                 [ViewController.view.window makeKeyAndVisible];
             }];
         }
         return YES;
     }else{
        return NO;
     }
}

@end
