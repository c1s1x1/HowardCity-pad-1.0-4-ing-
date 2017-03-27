//
//  CYLSameCityViewController.m
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "HCTaskViewController.h"
#import "CYLTabBarController.h"
#import "HCDetailsViewController.h"
#import "PublishViewController.h"
#import "ManageViewController.h"
#import "WorkingViewController.h"
#import "EndViewController.h"

@implementation HCTaskViewController

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:45])
    {
        
    }
    return self;
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HCColor(55, 106, 133, 1);
    
    self.navigationItem.title = @"任务";    //✅sets navigation bar title.The right way to set the title of the navigation
    
    NSArray *titleArray = @[
                            @"发布",
                            @"执行",
                            @"已完成",
                            ];
    
    NSArray *classNames = @[
                            [PublishViewController class],
                            [ManageViewController class],
                            [EndViewController class],
                            ];
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(UIScreenW/titleArray.count + 10, 45);
    self.selectedTitleColor = HCColor(192, 164, 60, 1);
    self.selectedIndicatorColor = HCColor(192, 164, 60, 1);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectTagByIndex:0 animated:YES];
    

}

@end
