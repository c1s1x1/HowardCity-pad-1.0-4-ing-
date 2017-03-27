//
//  DemoViewController.m
//  XBScrollPageControllerDemo
//
//  Created by Scarecrow on 15/9/8.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "NoticeViewController.h"
#import "HCMessageViewController.h"
#import "HCOleMessageController.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController
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
    
    self.title = @"通知";
    
    //    self.selectedIndicatorSize = CGSizeMake(30, 8);
    //    self.selectedTitleColor = [UIColor blueColor];
    //    self.selectedTitleFont = [UIFont systemFontOfSize:18];
    
    //    self.graceTime = 15;
    //    self.gapAnimated = YES;
    
//    self.backgroundColor = HCColor(55, 106, 133, 1);
//    self.coll
    
    NSArray *titleArray = @[
                            @"所有",
                            @"未读",
                            ];
    
    NSArray *classNames = @[
                            [HCMessageViewController class],
                            [HCOleMessageController class],
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
