//
//  CYLHomeViewController.h
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCStatuses.h"

//@protocol StatusesDelegate <NSObject>
//
//@optional
//- (void)sendStatuses:(HCStatuses *)Statuses;
//
//@end

@interface HCHomeViewController : UITableViewController

@property(nonatomic,strong)HCStatuses *Statuses;

//@property(nonatomic,assign)id<StatusesDelegate>delegate;

@end
