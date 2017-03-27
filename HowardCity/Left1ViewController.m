//
//  LeftViewController.m
//  ThreeViewsText
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 杨鹤. All rights reserved.
//

#import "Left1ViewController.h"

@interface Left1ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation Left1ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.alpha = 1;
    
    [self addConstraint];
    // Do any additional setup after loading the view.
}


/**
 *  创建控件, 添加约束
 */
- (void)addConstraint {
    // 头像图片
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_center_background"]];
    
    headImage.layer.masksToBounds = YES;
    
    headImage.layer.cornerRadius = 45;
    
    headImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:headImage];
    
    
    
    UILabel *UName = [[UILabel alloc]init];
    
    UName.text = @"姓名：萨芬的安抚";
    
    UName.font = HCStatusOriginalSCFont;
    
    UName.textColor = [UIColor whiteColor];
    
    UName.textAlignment = NSTextAlignmentLeft;
    
    UName.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UName];
    
    
    UILabel *USex = [[UILabel alloc]init];
    
    USex.text = @"性别：男";
    
    USex.font = HCStatusOriginalSCFont;
    
    USex.textColor = [UIColor whiteColor];
    
    USex.textAlignment = NSTextAlignmentLeft;
    
    USex.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:USex];
    
    
    
    UILabel *UQQ = [[UILabel alloc]init];
    
    UQQ.text = @"QQ：21233123321";
    
    UQQ.font = HCStatusOriginalSCFont;
    
    UQQ.textColor = [UIColor whiteColor];
    
    UQQ.textAlignment = NSTextAlignmentLeft;
    
    UQQ.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UQQ];
    
    
    
    UILabel *UBirthday = [[UILabel alloc]init];
    
    UBirthday.text = @"生日：1233123133";
    
    UBirthday.font = HCStatusOriginalSCFont;
    
    UBirthday.textColor = [UIColor whiteColor];
    
    UBirthday.textAlignment = NSTextAlignmentLeft;
    
    UBirthday.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UBirthday];
    
    
    
    
    UILabel *UPhone = [[UILabel alloc]init];
    
    UPhone.text = @"联系电话：1232331231";
    
    UPhone.font = HCStatusOriginalSCFont;
    
    UPhone.textColor = [UIColor whiteColor];
    
    UPhone.textAlignment = NSTextAlignmentLeft;
    
    UPhone.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UPhone];
    
    
    
    UILabel *UEmail = [[UILabel alloc]init];
    
    UEmail.text = @"电子邮箱：阿斯蒂芬暗的";
    
    UEmail.font = HCStatusOriginalSCFont;
    
    UEmail.textColor = [UIColor whiteColor];
    
    UEmail.textAlignment = NSTextAlignmentLeft;
    
    UEmail.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UEmail];
    
    
    
    UILabel *UCity = [[UILabel alloc]init];
    
    UCity.text = @"城市：广州";
    
    UCity.font = HCStatusOriginalSCFont;
    
    UCity.textColor = [UIColor whiteColor];
    
    UCity.textAlignment = NSTextAlignmentLeft;
    
    UCity.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UCity];
    
    
    
    UILabel *UPostcode = [[UILabel alloc]init];
    
    UPostcode.text = @"邮编：3342424";
    
    UPostcode.font = HCStatusOriginalSCFont;
    
    UPostcode.textColor = [UIColor whiteColor];
    
    UPostcode.textAlignment = NSTextAlignmentLeft;
    
    UPostcode.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UPostcode];
    
    
    
    
    UILabel *UWehar = [[UILabel alloc]init];
    
    UWehar.text = @"微信账号：阿斯蒂芬啊大";
    
    UWehar.font = HCStatusOriginalSCFont;
    
    UWehar.textColor = [UIColor whiteColor];
    
    UWehar.textAlignment = NSTextAlignmentLeft;
    
    UWehar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UWehar];
    
    
    
    
    UILabel *UCompany = [[UILabel alloc]init];
    
    UCompany.text = @"公司：无法玩儿 玩儿二";
    
    UCompany.font = HCStatusOriginalSCFont;
    
    UCompany.textColor = [UIColor whiteColor];
    
    UCompany.textAlignment = NSTextAlignmentLeft;
    
    UCompany.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:UCompany];
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headImage, UName, USex, UQQ, UBirthday, UPhone, UEmail,UCity,UPostcode,UWehar,UCompany);
    
    NSArray *imageHC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[headImage(90)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    
    NSArray *imageV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[headImage(90)]-5-[UName]-5-[USex]-5-[UQQ]-5-[UBirthday]-5-[UPhone]-5-[UEmail]-5-[UCity]-5-[UPostcode]-5-[UWehar]-5-[UCompany]-500-|" options:(NSLayoutFormatAlignAllCenterX) metrics:nil views:views];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:headImage attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0];
    
    
    NSArray *UNameArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UName]-50-|" options:0 metrics:0 views:views];
    
    NSArray *USexArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[USex]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UQQArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UQQ]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UBirthdayArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UBirthday]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UPhoneArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UPhone]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UEmailArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UEmail]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UCityArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UCity]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UPostcodeArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UPostcode]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UWeharArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UWehar]-0-|" options:0 metrics:0 views:views];
    
    NSArray *UCompanyArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UCompany]-0-|" options:0 metrics:0 views:views];
    
    
    
//    NSLayoutConstraint *UNameWigth = [NSLayoutConstraint constraintWithItem:UCompany attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:UWehar attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *USexWigth = [NSLayoutConstraint constraintWithItem:UCompany attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:UWehar attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UQQWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UBirthdayWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UPhoneWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UEmailWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UCityWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UPostcodeWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UWeharWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
//    
//    NSLayoutConstraint *UCompanyWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    
    [self.view addConstraint:centerX];
    
    [self.view addConstraints:imageHC];
    
    [self.view addConstraints:imageV];
    
    [self.view addConstraints:UNameArray];
    
    [self.view addConstraints:USexArray];
    
    [self.view addConstraints:UQQArray];
    
    [self.view addConstraints:UBirthdayArray];
    
    [self.view addConstraints:UPhoneArray];
    
    [self.view addConstraints:UEmailArray];
    
    [self.view addConstraints:UCityArray];
    
    [self.view addConstraints:UPostcodeArray];
    
    [self.view addConstraints:UWeharArray];
    
    [self.view addConstraints:UCompanyArray];
    
//    [self.view addConstraints:@[UNameWigth, USexWigth, UQQWigth, UBirthdayWigth, UPhoneWigth, UEmailWigth,UCityWigth,UPostcodeWigth,UWeharWigth,UCompanyWigth]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
