//
//  HCNavigationController.m
//  HowardCity
//
//  Created by CSX on 2017/1/9.
//  Copyright © 2017年 CSX. All rights reserved.
//

#import "HCNavigationController.h"

@interface HCNavigationController ()

@end

@implementation HCNavigationController

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

//只保证调用一次

+(void)initialize{
    
    if (self == [HCNavigationController class]) {
        
        //设置所有的导航了的背景颜色
        
        UINavigationBar  *bar = [UINavigationBar appearance];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            
            [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
            
            NSDictionary *dict =@{
                                  
                                  NSForegroundColorAttributeName:HCColor(44, 160, 249, 1),
                                  
                                  NSFontAttributeName:[UIFont systemFontOfSize:16]
                                  
                                  };
            
            [bar setTitleTextAttributes:dict];
            
            //设置主题
            
            [bar setTintColor:HCColor(44, 160, 249, 1)];
            
        }
        
    }
}

@end
