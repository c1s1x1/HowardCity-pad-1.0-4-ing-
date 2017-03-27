//
//  CYLHomeViewController.m
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLHomeViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "JSONKit.h"
#import "StoryCommentCell.h"
#import "HCMainViewController.h"
#import "ProjectEntity.h"
#import "HCUserInfo.h"
#import "HCStatuseCellFrame.h"
#import "HCStatuseCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HCLoginViewController.h"
#import "HowardCityTool.h"

@interface CYLHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isChange;
    BOOL _isH;
}
@property (nonatomic,strong) NSMutableArray *statusCellFrame;

@property (nonatomic,strong) NSMutableArray *statusCellFrameOld;

@property(nonatomic,strong)UIImage *image1;

@property(nonatomic,strong)HCAccount *account;

@end

@implementation CYLHomeViewController

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

-(NSMutableArray *)statuses{
    if (!_statusCellFrame) {
        _statusCellFrame = [NSMutableArray array];
    }
    
    return _statusCellFrame;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"项目列表"; //✅sets navigation bar title.The right way to set the title of the navigation
//    self.tabBarItem.title = @"首页23333";   //❌sets tab bar title. Even the `tabBarItem.title` changed, this will be ignored in tabbar.
//    self.title = @"首页1";                    //❌sets both of these. Do not do this‼️‼️This may cause something strange like this : http://i68.tinypic.com/282l3x4.jpg .
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    
    [self setTableviewInfo];
    
    [self initDate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ Controller Cell %@", self.tabBarItem.title, @(indexPath.row)]];
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
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=getProjectsOfUser&access_token=%@",HCInterfacePrefix,self.account.access_token];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *arry = [responseObject objectForKey:@"projectList"];
            NSMutableArray *cellFrmsM = [NSMutableArray array];
            for (id object in arry) {
                HCStatuseCellFrame *cellFrm = [[HCStatuseCellFrame alloc] init];
                HCStatuses *stat = [HCStatuses objectWithKeyValues:object];
                stat.username = [[NSString alloc]initWithFormat:@"创建者：%@",stat.username];
                stat.buildtime = [[NSString alloc]initWithFormat:@"创建时间：%@",stat.buildtime];
                cellFrm.statuse = stat;
                [cellFrmsM addObject:cellFrm];
            }
            for(NSUInteger i = 0; i < cellFrmsM.count - 1; i++) {
                for(NSUInteger j = 0; j < cellFrmsM.count - i - 1; j++) {
                    HCStatuseCellFrame *FileFirst = cellFrmsM[j];
                    HCStatuseCellFrame *FileSecond = cellFrmsM[j + 1];
                    NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.statuse.projectname];
                    NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.statuse.projectname];
                    //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                    if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                        HCStatuseCellFrame *tempString = cellFrmsM[j];
                        cellFrmsM[j] = cellFrmsM[j + 1];
                        cellFrmsM[j + 1] = tempString;
                    }
                }
            };
            self.statusCellFrame = cellFrmsM;
            [HUD hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
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
            [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initDate) userInfo:nil repeats:NO];
        }];
    }
    
}

-(void)setTableviewInfo{
    //设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}


#pragma mark -  3. 实现数据源（代理）方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusCellFrame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCStatuseCellFrame *cellFrame = self.statusCellFrame[indexPath.row];
    return [cellFrame cellHeight];
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.indentationLevel = 2; // 缩进级别
    cell.indentationWidth = 40.f; // 每个缩进级别的距离
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    HCStatuseCell *cell = [HCStatuseCell cellWithTabbleView:tableView];
    
    cell.statusCellFrm = self.statusCellFrame[indexPath.row];
    
    return cell;
}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = kCellIdentifier;
    cell = [self.tableView dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [StoryCommentCell storyCommentCellForTableWidth:self.tableView.frame.size.width];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSNumber *badgeNumber = @(indexPath.row + 1);
    HCMainViewController *exm    = [[HCMainViewController alloc] init];
    HCStatuseCell *cell          = [HCStatuseCell cellWithTabbleView:tableView];
    cell.statusCellFrm           = self.statusCellFrame[indexPath.row];
    exm.hidesBottomBarWhenPushed = NO;
    ProjectEntity *projectEntity       = [[ProjectEntity alloc]init];
    projectEntity.statuse           = cell.statusCellFrm.statuse;
    [exm setProjectEntity:projectEntity];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    dispatch_after(0.1, dispatch_get_main_queue(), ^{
        //这里跳转UI
        exm.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:exm animated:NO];
        //NSLog(@"%@",[NSThread currentThread]);
    });
//    self.navigationItem.title = [NSString stringWithFormat:@"首页(%@)", badgeNumber]; //sets navigation bar title.
//    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", badgeNumber]];
}

#pragma mark 监听屏幕的旋转 ，ios8以前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    HCLog(@"屏幕转了");
    NSMutableArray *cellFrmsM = [NSMutableArray array];
    for (HCStatuseCellFrame *object in self.statusCellFrame) {
        HCStatuseCellFrame *cellFrm = [[HCStatuseCellFrame alloc] init];
        cellFrm.statuse = object.statuse;
        [cellFrmsM addObject:cellFrm];
    };
    self.statusCellFrame = cellFrmsM;
    [self.tableView reloadData];
}

@end
