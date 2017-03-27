//
//  RootViewController.m
//  ThreeViewsText
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 杨鹤. All rights reserved.
//

#import "RootViewController.h"
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
@interface RootViewController ()
{
    BOOL _isChange;
    BOOL _isH;
}

@property (nonatomic, strong) UIImageView *backimage;

@property (nonatomic, strong) UIView *playView;

@end

@implementation RootViewController




- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  重写init方法
 */
- (id)initWithCenterVC:(CenterViewController *)centerVC rightVC:(RightViewController *)rightVC leftVC:(LeftViewController *)leftVC {

    
    if (self = [super init]) {
        [self addChildViewController:leftVC];
        [self addChildViewController:rightVC];
        
        UINavigationController *centerNC = [[UINavigationController alloc] initWithRootViewController:centerVC];
        [self addChildViewController:centerNC];
        
        
        leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
        
        rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
        centerNC.view.frame = [UIScreen mainScreen].bounds;
        
        self.view.backgroundColor = [UIColor colorWithRed:7/255.0 green:31/255.0 blue:52/255.0 alpha:1.0];
//        [self.view addSubview:self.backimage];
        [self.view addSubview:leftVC.view];
        [self.view addSubview:rightVC.view];
        [self.view addSubview:centerNC.view];
        
        centerVC.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *leftB = [[UIBarButtonItem alloc] initWithTitle:@"个人信息" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
            leftB;
        });
        if (UIScreenW >= 1024 || UIScreenH >= 1024) {
            [centerVC.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName,nil] forState:UIControlStateNormal];
        }else{
            [centerVC.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:10], NSFontAttributeName,nil] forState:UIControlStateNormal];
        }
        [centerVC.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
        
    }
    
    return self;
    
    
}


/**
 * 设置背景图片
 */
- (UIImageView *)backimage {

    if (!_backimage) {
        self.backimage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.backimage.backgroundColor = [UIColor colorWithRed:7/255.0 green:31/255.0 blue:52/255.0 alpha:1.0];
        
    }
    return _backimage;
}

/**
 *  左边按钮事件: rightVC 和 centerNC 向右偏移
 */
- (void)leftAction:(UIBarButtonItem *)sender {
    
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    RightViewController *rightVC = self.childViewControllers[1];
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    [UIView animateWithDuration:0.5 animations:^{
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            
            NSLog(@"1回来");
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            _isChange = !_isChange;
            return;
        }{
            
 
        centerNC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        rightVC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

            
        }
    }];
        
}

/**
 * 右边按钮事件: leftVC 和 centerNC 向左偏移
 */
- (void)rightAction:(UIBarButtonItem *)sender {
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    RightViewController *rightVC = self.childViewControllers[1];
    [UIView animateWithDuration:0.5 animations:^{
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            
            NSLog(@"1回来");
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
           
        }else{
            centerNC.view.frame = CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
