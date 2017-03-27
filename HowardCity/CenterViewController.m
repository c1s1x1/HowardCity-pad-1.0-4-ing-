#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "AFNetworking.h"
#import "HCStatuses.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "HCStatuseCellFrame.h"
#import "HCStatuseCell.h"
#import "StoryCommentCell.h"
#import "UIView+CZ.h"
#import "HCMainViewController.h"
#import "ProjectEntity.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "HCUserInfo.h"
#import "MBProgressHUD.h"
#import "NSString+ChineseCharactersToSpelling.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HCLoginViewController.h"
#import "HowardCityTool.h"


@interface CenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isChange;
    BOOL _isH;
}
@property (nonatomic,strong) NSMutableArray *statusCellFrame;

@property (nonatomic,strong) NSMutableArray *statusCellFrameOld;

@property(nonatomic,strong)UIImage *image1;

@property(nonatomic,strong)HCAccount *account;

@end

@implementation CenterViewController

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

- ( void ) viewWillAppear : ( BOOL ) animated {
    
    [ super viewWillAppear :animated ] ;
    
    CGRect rect = self . navigationController . navigationBar . frame ;
    
//    self . navigationController . navigationBar . frame = CGRectMake ( rect . origin . x , rect . origin . y , rect . size . width , 25 ) ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableviewInfo];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    
//    UIImage *NavigationLandscapeBackground;
//    if (UIScreenW >= 1024 || UIScreenH >= 1024) {
//        NavigationLandscapeBackground =[[UIImage imageNamed:@"title_pad"]
//                                        resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//    }else{
//        NavigationLandscapeBackground =[[UIImage imageNamed:@"title_molide"]
//                                        resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//    }
//    
//    [self.navigationController.navigationBar setBackgroundImage:NavigationLandscapeBackground forBarMetrics:UIBarMetricsDefault];
    
    // 轻扫手势
    UISwipeGestureRecognizer *leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipeGestureAction:)];
    
    // 设置清扫手势支持的方向
    leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // 添加手势
    [self.view addGestureRecognizer:leftswipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipeGestureAction:)];
    
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    [self initDate];
}


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
            NSMutableArray *arry = [responseObject objectForKey:@"projectList"];
            NSMutableArray *cellFrmsM = [NSMutableArray array];
            for (id object in arry) {
                HCStatuseCellFrame *cellFrm = [[HCStatuseCellFrame alloc] init];
                HCStatuses *stat = [HCStatuses objectWithKeyValues:object];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [self.navigationController pushViewController:exm animated:NO];
        //NSLog(@"%@",[NSThread currentThread]);
    });
    
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

/**
 *  左轻扫
 */
- (void)leftswipeGestureAction:(UISwipeGestureRecognizer *)sender {
    
    UINavigationController *centerNC = self.navigationController;
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            

            NSLog(@"1回来");
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            _isChange = !_isChange;
            return;
        }else {
            
            centerNC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            NSLog(@"左边");
            
        }
    }];
}

/**
 *  右轻扫
 */
- (void)rightswipeGestureAction:(UISwipeGestureRecognizer *)sender {
    UINavigationController *centerNC = self.navigationController;
    
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    
    
    [UIView animateWithDuration:0.5 animations:^{
    
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            NSLog(@"3回来");
            
        }else{
            centerNC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            NSLog(@"右边");

        }
    }];

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
