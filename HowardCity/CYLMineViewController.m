//
//  CYLMineViewController.m
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLMineViewController.h"
#import "CYLDetailsViewController.h"
#import "JSHeaderView.h"
#import "UserInfoCell.h"
#import "AFNetworking.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

static NSString *const kUserInfoCellId = @"kUserInfoCellId";

@interface CYLMineViewController () <UITableViewDelegate, UITableViewDataSource,UserInfoDelegate>

@property (nonatomic, strong) JSHeaderView *headerView;
@property (nonatomic, strong) HCUserInfo *UserInfo;
@property (nonatomic,strong) NSMutableDictionary *UserInfoArry;
@property(nonatomic,strong)HCAccount *account;

@end

@implementation CYLMineViewController

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

-(NSMutableDictionary *)statuses{
    if (!_UserInfoArry) {
        _UserInfoArry = [NSMutableDictionary dictionary];
    }
    
    return _UserInfoArry;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.account =[HCAuthTool user];
    [self setTableviewInfo];
    
    [self getHCUserInfo];
    self.headerView = [[JSHeaderView alloc] init];
    self.headerView.image =[UIImage imageNamed:@"home_back"];
    // 这个方法不需要在- (void)scrollViewDidScroll:(UIScrollView *)scrollView;方法中调用
    [self.headerView reloadSizeWithScrollView:self.tableView];
    self.navigationItem.titleView = self.headerView;
    [self.headerView handleClickActionWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您点击了头像" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = @"我的";    //✅sets navigation bar title.The right way to set the title of the navigation
    self.tabBarItem.title = @"我的23333";   //❌sets tab bar title. Even the `tabBarItem.title` changed, this will be ignored in tabbar.
    //self.title = @"我的1";                //❌sets both of these. Do not do this‼️‼️ This may cause something strange like this : http://i68.tinypic.com/282l3x4.jpg .
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
}

-(void)setTableviewInfo{
    //设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)getHCUserInfo{
    //获取user类
    //    HCAccount *user = [HCAuthTool user];
    
    //拼接url
    NSString *InfoUrl = [[NSString alloc]initWithFormat:@"%@action=getUserInfo&access_token=%@",HCInterfacePrefix,self.account.access_token];
    
    //创建manage
#pragma mark 拼接url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
#pragma mark 判断返回参数
    //获取项目数据
    [manager GET:InfoUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //把字典放入模型里
        self.UserInfo = [HCUserInfo objectWithKeyValues:responseObject];
        
        [self UserInfoToArry];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:self.UserInfo.imgpath
                                                              options:0
         
        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             //此处为下载进度
         }
        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             
                 //Update UI in UI thread her
         dispatch_sync(dispatch_get_main_queue(), ^{
             self.headerView.image = image;
             [self.headerView setNeedsDisplay];
             [self.tableView reloadData];
         });
//             self.headerView.frame = self.headerView.frame;
//             self.navigationItem.titleView.image = image;
         }];
        [self.tableView reloadData];
        HCLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"请求失败%@",error);
    }];
}

-(void)UserInfoToArry{
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    if (self.UserInfo.email) {
        [dic setObject:self.UserInfo.email forKey:@"邮箱"];
    }else{
        [dic setObject:@"空" forKey:@"邮箱"];
    }
    if (self.UserInfo.telephone) {
        [dic setObject:self.UserInfo.telephone forKey:@"电话"];
    }else{
        [dic setObject:@"空" forKey:@"电话"];
    }
    if (self.UserInfo.qq) {
        [dic setObject:self.UserInfo.qq forKey:@"QQ"];
    }else{
        [dic setObject:@"空" forKey:@"QQ"];
    }
    if (self.UserInfo.title) {
        [dic setObject:self.UserInfo.title forKey:@"职称"];
    }else{
        [dic setObject:@"空" forKey:@"职称"];
    }
    
    self.UserInfoArry = dic;
}

- (void)refreshtableview:(HCUserInfo *)User{
    
#pragma mark 等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"壕城云正更新个人信息...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Indeterminate mode
        sleep(2);
        // Switch to determinate mode
#pragma mark 拼接url
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=updateUserInfo&username=%@&sex=%@&birthday=%@&qq=%@&wechar=%@&telephone=%@&company=%@&companyaddess=%@&valuea=%@&access_token=%@",HCInterfacePrefix,User.username,User.sex,User.birthday,User.qq,User.wechat,User.telephone,User.company,User.companyaddess,User.title,self.account.access_token];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
#pragma mark 判断返回参数
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[[responseObject objectForKey:@"result"]stringValue] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.UserInfo = User;
                    [self UserInfoToArry];
                    HCLog(@"刷新个人信息");
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Set the text mode to show only text.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"莫名错误，更新失败，请重试", @"HUD message title");
                [hud hideAnimated:YES afterDelay:3.f];
                self.view.userInteractionEnabled = YES;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"网络问题，请稍后重试", @"HUD message title");
            HCLog(@"%@",error);
            [hud hideAnimated:YES afterDelay:3.f];
            self.view.userInteractionEnabled = YES;
        }];
    });
    
}

#pragma mark - Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 183.f;
    }
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        cell.delegate = self;
        if (!cell) {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserInfoCellId];
        }
        cell.UserInfo = self.UserInfo;
        cell.name = self.UserInfo.username;
        cell.info = self.UserInfo.company;
        cell.image = self.headerView.image;
        return cell;
    }
    NSString *CellThree = @"CellThree";
    // 设置tableview类型
    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellThree];
    // 设置不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"mycity_highlight"];// 图片
    NSArray *key = [self.UserInfoArry allKeys];
    NSArray *values = [self.UserInfoArry allValues];
    cell.textLabel.text = key[indexPath.row -1];// 文本
    cell.detailTextLabel.text = values[indexPath.row -1];// 子文本
//    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.UserInfoArry count] + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", @(indexPath.row + 1)]];
}

- (void)testPush {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
