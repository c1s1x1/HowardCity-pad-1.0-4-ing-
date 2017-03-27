//
//  CYLMessageViewController.m
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLMessageViewController.h"
#import "CYLTabBarController.h"
#import "HCNotice.h"
#import "HCNoticeCell.h"
#import "CYLDetailsViewController.h"
#import "KLCPopup.h"

@interface CYLMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)HCAccount *account;
@property (nonatomic,strong) NSMutableArray *NoticeCellFrame;
@property (nonatomic, strong) UILabel *Title;
@property (nonatomic, strong) UILabel *Description;
@property (nonatomic, strong) UILabel *SendTime;

@end

@implementation CYLMessageViewController

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

-(NSMutableArray *)statuses{
    if (!_NoticeCellFrame) {
        _NoticeCellFrame = [NSMutableArray array];
    }
    
    return _NoticeCellFrame;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通知";    //✅sets navigation bar title.The right way to set the title of the navigation
    self.tabBarItem.title = @"通知2333";   //❌sets tab bar title. Even the `tabBarItem.title` changed, this will be ignored in tabbar.
    //self.title = @"消息1";                //❌sets both of these. Do not do this‼️‼️ This may cause something strange like this : http://i68.tinypic.com/282l3x4.jpg .
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 配置参数
    self.tableView.buttonText = @"再次请求";
    self.tableView.buttonNormalColor = [UIColor redColor];
    self.tableView.buttonHighlightColor = [UIColor yellowColor];
    self.tableView.descriptionText = @"功能暂且未开放，come soon";
    
    [self setTableviewInfo];
    
    // 点击响应
    [self.tableView gzwLoading:^{
        NSLog(@"再点我就肛你");
        [self initDate];
    }];
    
    [self initDate];
}

-(void)setTableviewInfo{
    //设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view

-(void)initDate{
    if (![HowardCityTool TimeOut:self]) {
        self.view.userInteractionEnabled = NO;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        HUD.label.text =NSLocalizedString(@"Loading...", @"HUD loading title");
        // Set the details label text. Let's make it multiline this time.
        HUD.detailsLabel.text = NSLocalizedString(@"正在加载项目...", @"HUD title");
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=getReceivedInformations&access_token=%@",HCInterfacePrefix,self.account.access_token];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *arry = [responseObject objectForKey:@"informationList"];
            NSMutableArray *cellFrmsM = [NSMutableArray array];
            for (id object in arry) {
                HCNoticeCellFrame *cellFrm = [[HCNoticeCellFrame alloc] init];
                HCNotice *Notice = [HCNotice objectWithKeyValues:object];
                cellFrm.Notice = Notice;
                [cellFrmsM addObject:cellFrm];
            }
            for(NSUInteger i = 0; i < cellFrmsM.count - 1; i++) {
                for(NSUInteger j = 0; j < cellFrmsM.count - i - 1; j++) {
                    HCNoticeCellFrame *FileFirst = cellFrmsM[j];
                    HCNoticeCellFrame *FileSecond = cellFrmsM[j + 1];
                    NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Notice.sendTime];
                    NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Notice.sendTime];
                    //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                    if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                        HCNoticeCellFrame *tempString = cellFrmsM[j];
                        cellFrmsM[j] = cellFrmsM[j + 1];
                        cellFrmsM[j + 1] = tempString;
                    }
                }
            };
            self.NoticeCellFrame = cellFrmsM;
            [HUD hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled = YES;
            [self loadingData:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            HCLog(@"请求失败%@",error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            
            if (error.code == - 1005) {
                hud.label.text = NSLocalizedString(@"网络异常,稍后自动重试", @"HUD message title");
            }else if (error.code == -1001){
                hud.label.text = NSLocalizedString(@"请求超时,稍后自动重试", @"HUD message title");
            }else{
                hud.label.text = [[NSString alloc]initWithFormat:@"未知错误%ld,稍后自动重试",error.code];
            }
            [hud hideAnimated:YES afterDelay:3.f];
            self.view.userInteractionEnabled = YES;
            [self loadingData:NO];
            [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initDate) userInfo:nil repeats:NO];
        }];
    }
    
}

-(void)loadingData:(BOOL)data
{
    // 模拟延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (data) {
            self.tableView.loading = YES;
        }else {// 无数据时
            self.tableView.loading = NO;
        }
        [self.tableView reloadData];
    });
}

#pragma mark -  3. 实现数据源（代理）方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.NoticeCellFrame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCNoticeCellFrame *cellFrame = self.NoticeCellFrame[indexPath.row];
    return [cellFrame cellHeight];
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.indentationLevel = 2; // 缩进级别
    cell.indentationWidth = 40.f; // 每个缩进级别的距离
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    HCNoticeCell *cell = [HCNoticeCell cellWithTabbleView:tableView];
    
    cell.NoticeCellFrm = self.NoticeCellFrame[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIViewController *viewController = [[CYLDetailsViewController alloc] init];
//    //    viewController.hidesBottomBarWhenPushed = YES;  // This property needs to be set before pushing viewController to the navigationController's stack. Meanwhile as it is all base on CYLBaseNavigationController, there is no need to do this.
//    [self.navigationController pushViewController:viewController animated:YES];
    HCNoticeCellFrame *noticeCell = self.NoticeCellFrame[indexPath.row];
    [self showButtonPressed:noticeCell.Notice];
}

#pragma mark 监听屏幕的旋转 ，ios8以前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    HCLog(@"屏幕转了");
    NSMutableArray *cellFrmsM = [NSMutableArray array];
    for (HCNoticeCellFrame *object in self.NoticeCellFrame) {
        HCNoticeCellFrame *cellFrm = [[HCNoticeCellFrame alloc] init];
        cellFrm.Notice = object.Notice;
        [cellFrmsM addObject:cellFrm];
    };
    self.NoticeCellFrame = cellFrmsM;
    [self.tableView reloadData];
}

- (void)showButtonPressed:(HCNotice *)notice {
    
    // Generate content view to present
    UIView* contentView                                      = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints    = NO;
    contentView.backgroundColor = HCColor(255, 255, 255, 1);
//    contentView.layer.cornerRadius = 12.0;
//    contentView.layer.masksToBounds = YES;
    
    
#pragma mark 名字
    //名字输入框
    UILabel *Title                                        = [[UILabel alloc]init];
    Title.text                                                = notice.title;
    Title.font                                                = [UIFont systemFontOfSize:15];
    Title.textColor                                           = [UIColor blackColor];
    Title.backgroundColor = HCColor(0, 0, 0, 0.1);
    Title.textAlignment                                       = NSTextAlignmentCenter;//设置字体居左
    Title.translatesAutoresizingMaskIntoConstraints           = NO;//设置不绝对布局
    //分割线
    UIButton* TitleLine                                   = [UIButton buttonWithType:UIButtonTypeCustom];
    TitleLine.translatesAutoresizingMaskIntoConstraints   = NO;
    TitleLine.backgroundColor                             = [UIColor blackColor];
    
#pragma mark 职位
    //创建文字框Label框架
    UILabel *Describe                                    = [[UILabel alloc]init];
    //设置用户名
    Describe.text
    = notice.describe;
//    =@"通知详情通知详情通知详情通知详情通知详情大法师的法师法打发点啊发达爱的碍事案发生大发发打发斯蒂芬撒旦法阿道夫碍事发多少范德萨发爱迪生发烧大发放阿萨德碍事大发达";
    Describe.font                                            = [UIFont systemFontOfSize:15];
    Describe.numberOfLines = 5;//最多80个字
    Describe.lineBreakMode=NSLineBreakByWordWrapping;
    Describe.textAlignment = NSTextAlignmentCenter;//文字居中
//    Describe.backgroundColor = HCColor(87 , 255, 103, 1);
    //设置字体颜色
    Describe.textColor                                       = [UIColor blackColor];
    //设置字体居左
    Describe.textAlignment                                   = NSTextAlignmentLeft;
    Describe.translatesAutoresizingMaskIntoConstraints       = NO;
    
    
#pragma mark 邮箱
    //创建文字框Label框架
    UILabel *SendTime                                       = [[UILabel alloc]init];
    //设置用户名
    SendTime.text                                               = notice.sendTime;
    SendTime.font                                               = [UIFont systemFontOfSize:15];
//    SendTime.backgroundColor = HCColor(156, 135, 207, 1);
    //设置字体颜色
    SendTime.textColor                                          = [UIColor grayColor];
    //设置字体居左
    SendTime.textAlignment                                      = NSTextAlignmentRight;
    SendTime.translatesAutoresizingMaskIntoConstraints          = NO;
    
#pragma mark 提交按钮
    UIButton* CommitButton                                   = [UIButton buttonWithType:UIButtonTypeCustom];
    CommitButton.translatesAutoresizingMaskIntoConstraints   = NO;
    //    CommitButton.layer.cornerRadius = 6.0;
    CommitButton.contentEdgeInsets                           = UIEdgeInsetsMake(10, 20, 10, 20);
    CommitButton.backgroundColor                             = HCColor(219, 158, 50, 1);
    [CommitButton setTitleColor:HCColor(255, 255, 255,1) forState:UIControlStateNormal];
    [CommitButton setTitleColor:[[CommitButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    CommitButton.titleLabel.font                             = [UIFont boldSystemFontOfSize:16.0];
    CommitButton.layer.cornerRadius = 12.0;
    CommitButton.layer.masksToBounds = YES;
    [CommitButton setTitle:@"确认" forState:UIControlStateNormal];
    [CommitButton addTarget:self action:@selector(CommitButtonButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加到当前页面
    [contentView addSubview:Title];
    [contentView addSubview:Describe];
    [contentView addSubview:SendTime];

    [contentView addSubview:CommitButton];
    self.Title       = Title;
    self.Description = Describe;
    self.SendTime    = SendTime;
    NSDictionary* views                                      = NSDictionaryOfVariableBindings(contentView,
                                                                                              Title,
                                                                                              Describe,
                                                                                              SendTime,
                                                                                              CommitButton);
    
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"V:|[Title(40)][Describe(100)][SendTime(20)][CommitButton]-(5)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"H:|[Title]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"H:|[Describe(300)]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"H:|[SendTime]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    
    // Show in popup
    KLCPopupLayout layout                                    = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                                                                  (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup                                          = [KLCPopup popupWithContentView:contentView
                                                                                     showType:(KLCPopupShowType)KLCPopupShowTypeBounceInFromTop
                                                                                  dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
                                                                                     maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                                                                     dismissOnBackgroundTouch:YES
                                                                        dismissOnContentTouch:NO];
    
    
    [popup showWithLayout:layout];
    
}

- (void)CommitButtonButtonPressed:(id)sender{
    HCLog(@"hahahahahaahahahahahahaah");
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}

@end
