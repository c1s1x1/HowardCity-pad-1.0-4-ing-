//
//  PlusButtonViewController.m
//  HowardCity
//
//  Created by CSX on 2017/2/13.
//  Copyright © 2017年 CSX. All rights reserved.
//

#import "PlusButtonViewController.h"
#import "CCLayerAnimation.h"
#import "PublishTaskViewController.h"
#import "CCNavigationController.h"

@interface PlusButtonViewController ()

@end

@implementation PlusButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = HCColor(0, 0, 0, 1);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    //给bgView边框设置阴影
    button.layer.shadowOffset = CGSizeMake(1,1);
    button.layer.shadowOpacity = 0.3;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    CGFloat buttonW = UIScreenW/2;
    CGFloat buttonX = UIScreenW/2 - 150;
    CGFloat buttonH = 200;
    button.frame = CGRectMake(buttonX, buttonH, 300, 50);
    button.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:button];
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
    [button addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)clickPublish{
    
    PublishTaskViewController *viewController = [[PublishTaskViewController alloc] init];
    
    //初始化导航控制器
    CCNavigationController *fancyNavigationController =[[CCNavigationController alloc] initWithRootViewController:viewController];

    //初始化动画效果
//    CCLayerAnimation *LayerAnimation = [[CCLayerAnimation alloc] init];
//    fancyNavigationController.interactionEnabled = YES;
    fancyNavigationController.interactionEnabled = YES;
    //设置动画效果
    id transitionInstance = [[NSClassFromString(@"CCLayerAnimation") alloc] init];
    fancyNavigationController.animationController = transitionInstance;
    fancyNavigationController.animationController.type = 0;

    //设置代理
//    viewController.transitioningDelegate = self.transitioningDelegate;
    self.hidesBottomBarWhenPushed=YES;
    //进行 Modal 操作
    [self.navigationController pushViewController:viewController animated:YES ];
    self.hidesBottomBarWhenPushed=NO;
    
}

@end
