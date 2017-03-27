//
//  HCMainViewController.h
//  HowardCity
//
//  Created by 紫月 on 16/4/18.
//  Copyright (c) 2016年 CSX. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HCStatuses.h"
#import "ProjectEntity.h"
#import <Foundation/Foundation.h>

@interface HCMainViewController : UIViewController

@property(nonatomic,strong)HCStatuses *statuse;

@property(nonatomic,retain)ProjectEntity *projectEntity;

@end
