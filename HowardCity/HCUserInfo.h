//
//  HCUserInfo.h
//  HowardCity
//
//  Created by CSX on 16/4/25.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCUserInfo : NSObject

//生日
@property(nonatomic,copy)NSString *birthday;
//qq
@property(nonatomic,copy)NSString *qq;
//头像
@property(nonatomic,copy)NSURL *imgpath;
//性别
@property(nonatomic,copy)NSString *sex;
//微信
@property(nonatomic,copy)NSString *wechat;
//用户类型
@property(nonatomic,copy)NSString *usertype;
//公司地址
@property(nonatomic,copy)NSString *companyaddess;
//电话
@property(nonatomic,copy)NSString *telephone;
//公司职位
@property(nonatomic,copy)NSString *title;
//公用户创建时间
@property(nonatomic,copy)NSString *buildtime;
//公司名称
@property(nonatomic,copy)NSString *company;
//邮箱
@property(nonatomic,copy)NSString *email;
//姓名
@property(nonatomic,copy)NSString *username;
//项目ID
@property(nonatomic,copy)NSString *projectid;
//用户ID
@property(nonatomic,copy)NSString *userid;

@end
