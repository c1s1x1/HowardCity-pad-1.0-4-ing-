//
//  WorkingViewController.m
//  HowardCity
//
//  Created by CSX on 2017/1/9.
//  Copyright © 2017年 CSX. All rights reserved.
//

#import "WorkingViewController.h"
#import "HCTask.h"
#import "HCTaskCell.h"
#import "HCDetailsViewController.h"

@interface WorkingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)HCAccount *account;
@property (nonatomic,strong) NSMutableArray *TaskCellFrm;

@end

@implementation WorkingViewController

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

-(NSMutableArray *)statuses{
    if (!_TaskCellFrm) {
        _TaskCellFrm = [NSMutableArray array];
    }
    
    return _TaskCellFrm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = HCColor(55, 106, 133, 1);
    self.tableView.backgroundColor = HCColor(55, 106, 133, 1);
    // 配置参数
    self.tableView.buttonText = @"再次获取";
    self.tableView.buttonNormalColor = [UIColor redColor];
    self.tableView.buttonHighlightColor = [UIColor yellowColor];
    self.tableView.descriptionText = @"您暂且没有进行中的任务";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.loading = YES;
    
    [self setTableviewInfo];
    
    [self initDate];
    
    // 点击响应
    [self.tableView gzwLoading:^{
        NSLog(@"再点我就肛你");
        [self initDate];
    }];
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
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=getDoingTasks&access_token=%@",HCInterfacePrefix,self.account.access_token];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *arry = [responseObject objectForKey:@"taskList"];
            NSMutableArray *cellFrmsM = [NSMutableArray array];
            for (id object in arry) {
                HCTaskCellFrame *cellFrm = [[HCTaskCellFrame alloc] init];
                HCTask *Task = [HCTask objectWithKeyValues:object];
                if ([Task.taskstate isEqualToString:@"2"]) {
                    Task.taskform = @"已完成";
                    cellFrm.Task = Task;
                    [cellFrmsM addObject:cellFrm];
                }
            }
            if (cellFrmsM.count == 0) {
                self.view.userInteractionEnabled = YES;
                [self loadingData:NO];
                [HUD hideAnimated:YES];
                return ;
            }
            for(NSUInteger i = 0; i < cellFrmsM.count - 1; i++) {
                for(NSUInteger j = 0; j < cellFrmsM.count - i - 1; j++) {
                    HCTaskCellFrame *FileFirst = cellFrmsM[j];
                    HCTaskCellFrame *FileSecond = cellFrmsM[j + 1];
                    NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Task.buildtime];
                    NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Task.buildtime];
                    //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                    if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                        HCTaskCellFrame *tempString = cellFrmsM[j];
                        cellFrmsM[j] = cellFrmsM[j + 1];
                        cellFrmsM[j + 1] = tempString;
                    }
                }
            }
            self.TaskCellFrm = cellFrmsM;
            [HUD hideAnimated:YES afterDelay:0.f];
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
            [hud hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled = YES;
            [self loadingData:NO];
            [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initDate) userInfo:nil repeats:NO];
        }];
    }
    
}

-(void)loadingData:(BOOL)data
{
    if (data) {
        self.tableView.loading = YES;
    }else {// 无数据时
        self.tableView.loading = NO;
    }
    [self.tableView reloadData];
}

#pragma mark -  3. 实现数据源（代理）方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.TaskCellFrm.count;
    //    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCTaskCellFrame *cellFrame = self.TaskCellFrm[indexPath.row];
    return [cellFrame cellHeight];
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.indentationLevel = 2; // 缩进级别
    cell.indentationWidth = 40.f; // 每个缩进级别的距离
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    HCTaskCell *cell = [HCTaskCell cellWithTabbleView:tableView];
    
    cell.TaskCellFrm = self.TaskCellFrm[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    //    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    //    cell.textLabel.text = @"执行任务";
    //    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HCDetailsViewController *DetailsController = [[HCDetailsViewController alloc] init];
//    HCTaskCell *cell = [HCTaskCell cellWithTabbleView:tableView];
//    cell.TaskCellFrm = self.TaskCellFrm[indexPath.row];
//    DetailsController.Task = cell.TaskCellFrm.Task;
    [self.navigationController pushViewController:DetailsController animated:YES];
}

#pragma mark 监听屏幕的旋转 ，ios8以前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    HCLog(@"屏幕转了");
    NSMutableArray *cellFrmsM = [NSMutableArray array];
    for (HCTaskCellFrame *object in self.TaskCellFrm) {
        HCTaskCellFrame *cellFrm = [[HCTaskCellFrame alloc] init];
        cellFrm.Task = object.Task;
        [cellFrmsM addObject:cellFrm];
    };
    self.TaskCellFrm = cellFrmsM;
    [self.tableView reloadData];
}

@end
