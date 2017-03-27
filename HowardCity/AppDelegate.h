//
//  AppDelegate.h
//  HowardCity
//
//  Created by 紫月 on 16/4/15.
//  Copyright (c) 2016年 CSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)BOOL allowRotation;//是否允许转向

@property(nonatomic,assign)NSInteger rotation_Style;

@end

