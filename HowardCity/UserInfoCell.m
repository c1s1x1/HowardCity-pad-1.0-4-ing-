//
//  UserInfoCell.m
//  JSHeaderView
//
//  Created by 雷亮 on 16/8/1.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "UserInfoCell.h"
#import "KLCPopup.h"
#import "AFNetworking.h"

@interface UserInfoCell ()

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *infoLabel;
@property (nonatomic, strong) UIButton    *editInfoButton;
@property (nonatomic, strong) KLCPopup    *popupView;
@property (nonatomic, strong) UITextField *NameU;
@property (nonatomic, strong) UITextField *Position;
@property (nonatomic, strong) UITextField *Email;
@property (nonatomic, strong) UITextField *Telephone;
@property (nonatomic, strong) UITextField *QQ;
@property (nonatomic, strong) UITextField *Company;
@end

@implementation UserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self                                                     = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    self.selectionStyle                                      = UITableViewCellSelectionStyleNone;

        [self addSubview:self.nameLabel];
        [self addSubview:self.infoLabel];
        [self addSubview:self.editInfoButton];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
    _nameLabel                                               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _nameLabel.center                                        = CGPointMake(kScreenWidth / 2, 60);
    _nameLabel.text                                          = self.UserInfo.username;
    _nameLabel.textAlignment                                 = 1;
    _nameLabel.backgroundColor                               = [UIColor clearColor];
    _nameLabel.textColor                                     = [UIColor whiteColor];
    _nameLabel.font                                          = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}

-(void)setName:(NSString *)name{
    _name                                                    = name;
    self.nameLabel.text                                      = name;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
    _infoLabel                                               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    _infoLabel.center                                        = CGPointMake(kScreenWidth / 2, 99);
    _infoLabel.text                                          = self.UserInfo.company;
    _infoLabel.textAlignment                                 = 1;
    _infoLabel.backgroundColor                               = [UIColor clearColor];
    _infoLabel.textColor                                     = [UIColor whiteColor];
    _infoLabel.numberOfLines                                 = 0;
    _infoLabel.font                                          = [UIFont systemFontOfSize:11];
    }
    return _infoLabel;
}

-(void)setInfo:(NSString *)info{
    _info                                                    = info;
    self.infoLabel.text                                      = info;
}

- (UIButton *)editInfoButton {
    if (!_editInfoButton) {
    _editInfoButton                                          = [UIButton buttonWithType:UIButtonTypeCustom];
    _editInfoButton.frame                                    = CGRectMake(0, 0, 86, 27);
    _editInfoButton.center                                   = CGPointMake(kScreenWidth / 2, 145);
        [_editInfoButton setTitle:@"编辑个人资料" forState:UIControlStateNormal];
    _editInfoButton.titleLabel.font                          = [UIFont boldSystemFontOfSize:11];
        [_editInfoButton setTitleColor:HCColor(255, 255, 255, 1) forState:UIControlStateNormal];
//    _editInfoButton.layer.borderColor                        = HCColor(219, 158, 50, 1).CGColor;
//    _editInfoButton.layer.cornerRadius                       = 2;
//    _editInfoButton.layer.borderWidth                        = 1.0f;
        _editInfoButton.backgroundColor = HCColor(192, 164, 60, 1);
        [_editInfoButton addTarget:self action:@selector(handleEditAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editInfoButton;
}

- (void)setImage:(UIImage *)image {
    _image                                                   = image;
}

- (void)handleEditAction:(UIButton *)sender {
    HCLog(@"编辑个人资料了");
    [self showButtonPressed:sender];
}

- (void)showButtonPressed:(id)sender {

    // Generate content view to present
    UIView* contentView                                      = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints    = NO;
    contentView.backgroundColor = HCColor(244, 206, 113, 1);
    contentView.layer.cornerRadius = 12.0;
    contentView.layer.masksToBounds = YES;

#pragma mark 头像
    // 头像图片
    //创建图片框架，并设置背景图片为home_back
    UIImageView *headImage                                   = [[UIImageView alloc] init];
    headImage.image                                          = _image;
    //设置圆角
    headImage.layer.masksToBounds                            = YES;
    headImage.layer.cornerRadius                             = 40;
//    headImage.layer.shadowOpacity = 1;// 阴影透明度
//    headImage.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
//    headImage.layer.shadowRadius = 10;// 阴影扩散的范围控制
//    headImage.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    headImage.layer.borderColor                              = [UIColor whiteColor].CGColor;//边框颜色
    headImage.layer.borderWidth                              = 2;//边框宽度
    //设置不绝对布局
    headImage.translatesAutoresizingMaskIntoConstraints      = NO;

#pragma mark 名字
    //名字图标
    UIImageView *NameImage                                   = [[UIImageView alloc] init];
    NameImage.image                                          = [UIImage imageNamed:@"姓名 (1)"];
    NameImage.translatesAutoresizingMaskIntoConstraints      = NO;//设置不绝对布局
    //名字输入框
    UITextField *Name                                        = [[UITextField alloc]init];
    Name.text                                                = self.UserInfo.username;
    Name.font                                                = [UIFont systemFontOfSize:15];
    Name.textColor                                           = [UIColor blackColor];
    Name.textAlignment                                       = NSTextAlignmentLeft;//设置字体居左
    Name.translatesAutoresizingMaskIntoConstraints           = NO;//设置不绝对布局
    Name.enabled = false;
    //分割线
    UIButton* NameLine                                       = [UIButton buttonWithType:UIButtonTypeCustom];
    NameLine.translatesAutoresizingMaskIntoConstraints       = NO;
    NameLine.backgroundColor                                 = [UIColor whiteColor];

#pragma mark 职位
    //创建图片框架，并设置背景图片为home_back
    UIImageView *PositionImage                               = [[UIImageView alloc] init];
    PositionImage.image                                      = [UIImage imageNamed:@"职称 (1)"];
    //设置不绝对布局
    PositionImage.translatesAutoresizingMaskIntoConstraints  = NO;
    //创建文字框Label框架
    UITextField *Position                                    = [[UITextField alloc]init];
    //设置用户名
    Position.text                                            = self.UserInfo.title;
    Position.font                                            = [UIFont systemFontOfSize:15];
    //设置字体颜色
    Position.textColor                                       = [UIColor blackColor];
    //设置字体居左
    Position.textAlignment                                   = NSTextAlignmentLeft;
    Position.translatesAutoresizingMaskIntoConstraints       = NO;
    //分割线
    UIButton* PositionLine                                   = [UIButton buttonWithType:UIButtonTypeCustom];
    PositionLine.translatesAutoresizingMaskIntoConstraints   = NO;
    PositionLine.backgroundColor                             = [UIColor blackColor];

#pragma mark 邮箱
    //创建图片框架，并设置背景图片为home_back
    UIImageView *EmailImage                                  = [[UIImageView alloc] init];
    EmailImage.image                                         = [UIImage imageNamed:@"邮箱 (1)"];
    //设置不绝对布局
    EmailImage.translatesAutoresizingMaskIntoConstraints     = NO;
    //创建文字框Label框架
    UITextField *Email                                       = [[UITextField alloc]init];
    //设置用户名
    Email.text                                               = self.UserInfo.email;
    Email.font                                               = [UIFont systemFontOfSize:15];
    //设置字体颜色
    Email.textColor                                          = [UIColor blackColor];
    //设置字体居左
    Email.textAlignment                                      = NSTextAlignmentLeft;
    Email.translatesAutoresizingMaskIntoConstraints          = NO;
    //分割线
    UIButton* EmailLine                                      = [UIButton buttonWithType:UIButtonTypeCustom];
    EmailLine.translatesAutoresizingMaskIntoConstraints      = NO;
    EmailLine.backgroundColor                                = [UIColor whiteColor];

#pragma mark 电话
    //创建图片框架，并设置背景图片为home_back
    UIImageView *TelephoneImage                              = [[UIImageView alloc] init];
    TelephoneImage.image                                     = [UIImage imageNamed:@"电话 (1)"];
    //设置不绝对布局
    TelephoneImage.translatesAutoresizingMaskIntoConstraints = NO;
    //创建文字框Label框架
    UITextField *Telephone                                   = [[UITextField alloc]init];
    //设置用户名
    Telephone.text                                           = self.UserInfo.telephone;
    Telephone.font                                           = [UIFont systemFontOfSize:15];
    //设置字体颜色
    Telephone.textColor                                      = [UIColor blackColor];
    //设置字体居左
    Telephone.textAlignment                                  = NSTextAlignmentLeft;
    Telephone.translatesAutoresizingMaskIntoConstraints      = NO;
    //分割线
    UIButton* TelephoneLine                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    TelephoneLine.translatesAutoresizingMaskIntoConstraints  = NO;
    TelephoneLine.backgroundColor                            = [UIColor whiteColor];

#pragma mark QQ
    //创建图片框架，并设置背景图片为home_back
    UIImageView *QQImage                                     = [[UIImageView alloc] init];
    QQImage.image                                            = [UIImage imageNamed:@"qq (1)"];
    //设置不绝对布局
    QQImage.translatesAutoresizingMaskIntoConstraints        = NO;
    //创建文字框Label框架
    UITextField *QQ                                          = [[UITextField alloc]init];
    //设置用户名
    QQ.text                                                  = self.UserInfo.qq;
    QQ.font                                                  = [UIFont systemFontOfSize:15];
    //设置字体颜色
    QQ.textColor                                             = [UIColor blackColor];
    //设置字体居左
    QQ.textAlignment                                         = NSTextAlignmentLeft;
    QQ.translatesAutoresizingMaskIntoConstraints             = NO;
    //分割线
    UIButton* QQLine                                         = [UIButton buttonWithType:UIButtonTypeCustom];
    QQLine.translatesAutoresizingMaskIntoConstraints         = NO;
    QQLine.backgroundColor                                   = [UIColor whiteColor];

#pragma mark 公司名称
    //创建图片框架，并设置背景图片为home_back
    UIImageView *CompanyImage                                = [[UIImageView alloc] init];
    CompanyImage.image                                       = [UIImage imageNamed:@"公司 (1)"];
    //设置不绝对布局
    CompanyImage.translatesAutoresizingMaskIntoConstraints   = NO;
    //创建文字框Label框架
    UITextField *Company                                     = [[UITextField alloc]init];
    //设置用户名
    Company.text                                             = self.UserInfo.company;
    Company.font                                             = [UIFont systemFontOfSize:15];
    //设置字体颜色
    Company.textColor                                        = [UIColor blackColor];
    //设置字体居左
    Company.textAlignment                                    = NSTextAlignmentLeft;
    Company.translatesAutoresizingMaskIntoConstraints        = NO;
    //分割线
    UIButton* CompanyLine                                    = [UIButton buttonWithType:UIButtonTypeCustom];
    CompanyLine.translatesAutoresizingMaskIntoConstraints    = NO;
    CompanyLine.backgroundColor                              = HCColor(0, 0, 0, 0.3);

#pragma mark 提交按钮
    UIButton* CommitButton                                   = [UIButton buttonWithType:UIButtonTypeCustom];
    CommitButton.translatesAutoresizingMaskIntoConstraints   = NO;
//    CommitButton.layer.cornerRadius = 6.0;
    CommitButton.contentEdgeInsets                           = UIEdgeInsetsMake(10, 20, 10, 20);
    CommitButton.backgroundColor                             = HCColor(192, 164, 60, 1);
    [CommitButton setTitleColor:HCColor(255, 255, 255,1) forState:UIControlStateNormal];
    [CommitButton setTitleColor:[[CommitButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    CommitButton.titleLabel.font                             = [UIFont boldSystemFontOfSize:16.0];
    [CommitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [CommitButton addTarget:self action:@selector(CommitButtonButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    //添加到当前页面
    [contentView addSubview:headImage];
    [contentView addSubview:NameImage];
    [contentView addSubview:Name];
//    [contentView addSubview:NameLine];
    [contentView addSubview:PositionImage];
    [contentView addSubview:Position];
//    [contentView addSubview:PositionLine];
    [contentView addSubview:EmailImage];
    [contentView addSubview:Email];
//    [contentView addSubview:EmailLine];
    [contentView addSubview:TelephoneImage];
    [contentView addSubview:Telephone];
//    [contentView addSubview:TelephoneLine];
    [contentView addSubview:QQImage];
    [contentView addSubview:QQ];
//    [contentView addSubview:QQLine];
    [contentView addSubview:CompanyImage];
    [contentView addSubview:Company];
    [contentView addSubview:CompanyLine];
    [contentView addSubview:CommitButton];
    self.NameU                                               = Name;
    self.Position                                            = Position;
    self.Email                                               = Email;
    self.Telephone                                           = Telephone;
    self.QQ                                                  = QQ;
    self.Company                                             = Company;
    NSDictionary* views                                      = NSDictionaryOfVariableBindings(headImage,
                                                                                         NameImage,
                                                                                         Name,
//                                                                                         NameLine,
                                                                                         PositionImage,
                                                                                         Position,
//                                                                                         PositionLine,
                                                                                         EmailImage,
                                                                                         Email,
//                                                                                         EmailLine,
                                                                                         TelephoneImage,
                                                                                         Telephone,
//                                                                                         TelephoneLine,
                                                                                         QQImage,
                                                                                         QQ,
//                                                                                         QQLine,
                                                                                         CompanyImage,
                                                                                         Company,
                                                                                         CompanyLine,
                                                                                         CommitButton);

    //设置高度
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headImage(80)]" options:0 metrics:nil views:views]];
    //设置宽度
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[headImage(80)]" options:0 metrics:nil views:views]];
    //垂直居中
//    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:headImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"V:|-(16)-[headImage(80)]-(5)-[NameImage]"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"V:[Name]-(5)-[Position]-(5)-[Email]-(5)-[Telephone]-(5)-[QQ]-(5)-[Company]-(>=0)-|"
                                             options:NSLayoutFormatAlignAllLeft
                                             metrics:nil
                                               views:views]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
       @"V:[NameImage(24)]-(5)-[PositionImage(==NameImage)]-(5)-[EmailImage(==NameImage)]-(5)-[TelephoneImage(==NameImage)]-(5)-[QQImage(==NameImage)]-(5)-[CompanyImage(==NameImage)]-(5)-[CompanyLine(1)][CommitButton(24)]|"
                                             options:NSLayoutFormatAlignAllLeft
                                             metrics:nil
                                               views:views]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"H:[Name(150)]"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"H:|[CompanyLine]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"H:|[CommitButton]|"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
       @"H:|-(10)-[NameImage(24)]-(5)-[Name(==Position)]-(10)-|"
                                             options:NSLayoutFormatAlignAllBottom
                                             metrics:nil
                                               views:views]];

    NSArray* NamevVews                                       = [[NSArray alloc] initWithObjects:@"Name",@"Position",@"Email",@"Telephone",@"QQ",@"Company",nil];
    int j;
    for (int i = 0; i < [NamevVews count]; i++){
//        [contentView addConstraints:
//         [NSLayoutConstraint constraintsWithVisualFormat:
//          [[NSString alloc]initWithFormat:@"H:[%@(==%@Line)]",[[NamevVews objectAtIndex:i] copy],[[NamevVews objectAtIndex:i] copy]]
//                                                 options:NSLayoutFormatAlignAllTop
//                                                 metrics:nil
//                                                   views:views]];
        j = i;
        if ((i+1)==[NamevVews count]) {
            j = -1;
        }
        [contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:
          [[NSString alloc]initWithFormat:@"H:|-(10)-[%@Image(24)]-(5)-[%@(==%@)]-(10)-|",[[NamevVews objectAtIndex:i] copy],[[NamevVews objectAtIndex:i] copy],[[NamevVews objectAtIndex:j+1] copy]]
                                                 options:NSLayoutFormatAlignAllBottom
                                                 metrics:nil
                                                   views:views]];
    }


    // Show in popup
    KLCPopupLayout layout                                    = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);

    KLCPopup* popup                                          = [KLCPopup popupWithContentView:contentView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOut
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];


    [popup showWithLayout:layout];

}

- (void)CommitButtonButtonPressed:(id)sender{
    HCLog(@"个人信息已修改");
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    self.UserInfo.username = self.NameU.text;
    self.UserInfo.title = self.Position.text;
    self.UserInfo.email = self.Email.text;
    self.UserInfo.telephone = self.Telephone.text;
    self.UserInfo.qq = self.QQ.text;
    self.UserInfo.company = self.Company.text;
    if ([_delegate respondsToSelector:@selector(refreshtableview:)]) {
        [_delegate refreshtableview:self.UserInfo];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
