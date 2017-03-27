//
//  HCMainViewController.m
//  HowardCity
//
//  Created by 紫月 on 16/4/18.
//  Copyright (c) 2016年 CSX. All rights reserved.
//

#import "HCMainViewController.h"
#import "ProjectEntity.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "HCFilerecord.h"
#import "MBProgressHUD.h"
#import "UIView+CZ.h"
#import "HCFileCellFrame.h"
#import "HCFileCell.h"
#import "StoryCommentCell.h"
#import <QuickLook/QuickLook.h>
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "RootViewController.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "HCUserInfo.h"
#import "NSString+ChineseCharactersToSpelling.h"
#import "AppDelegate.h"
#import "HVTESTviewcontroller.h"
#import "CYLTabBarControllerConfig.h"
#import "CYLPlusButtonSubclass.h"
#import "HeadLineView.h"
#import "SortWithResponse.h"
#import "HCHomeViewController.h"
#import "NewFolderViewController.h"
#import "STPopup/STPopup.h"

@interface HCMainViewController ()<headLineDelegate,UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    BOOL _IsClickAgain;
    YiRefreshHeader *refreshHeader;
}
@property(nonatomic,strong)UIImageView *backgroundImgV;//背景图
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,assign)float backImgOrgy;
@property(nonatomic,strong)UIImageView *headImageView;//头视图
@property(nonatomic,strong)HeadLineView *headLineView;//
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)int rowHeight;

//文件夹数组
@property (nonatomic,strong) NSMutableArray *FilesCellFrame;
//目录路径数组
@property (nonatomic,strong) NSMutableArray *TemporaryArray;
//预览参数
@property (nonatomic,strong) UIDocumentInteractionController *documentController;
//目录路径数组
@property (nonatomic,strong) NSMutableArray *FilePathArray;
//目录路径
@property (nonatomic,strong) UILabel *FilePath;
//连续点击判断（是否同一行）
@property (nonatomic,assign) NSInteger Index;
//根目录判断变量
@property (nonatomic,assign) NSInteger flag;

@property(nonatomic,strong)HCAccount *account;

@property(nonatomic,strong)NSURL *fileUrl;

@property(nonatomic,strong) QLPreviewController *previewController;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HCMainViewController

@synthesize projectEntity;

#pragma mark 懒加载FilePathArray
-(NSMutableArray *)FilePathArray{
    if (!_FilePathArray) {
        _FilePathArray = [NSMutableArray array];
    }
    
    return _FilePathArray;
}


- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HCColor(44, 160, 249, 1);
    
    //拉伸顶部图片
    [self lashenBgView];
    
    //创建TableView
    [self createTableView];
    
    //右侧的菜单按钮
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [menuBtn addTarget:self action:@selector(Popup) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setImage:[UIImage imageNamed:@"nemuItem"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=self.tableView;
    [refreshHeader header];
    typeof(refreshHeader) __weak weakRefreshHeader = refreshHeader;
    id __weak tmp = self;
    NSString *projectid = self.projectEntity.statuse.projectid;
    refreshHeader.beginRefreshingBlock=^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(weakRefreshHeader) __strong strongRefreshHeader = weakRefreshHeader;
            // 主线程刷新视图
            [tmp OpenProjectWithProjectid:projectid];
            [strongRefreshHeader endRefreshing];
        });
    };
    
    _currentIndex=0;
#pragma mark 获取初始数据
    [self OpenProjectWithProjectid:self.projectEntity.statuse.projectid];
    
    self.flag = 1;
}

-(void)Popup{
    [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:1.0];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:18],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[STPopupNavigationBar class], nil] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Cochin" size:17] } forState:UIControlStateNormal];
    NewFolderViewController *NewFolder  = [[NewFolderViewController alloc] init];
    [NewFolder setProjectID:self.projectEntity.statuse.projectid];
    HCFilerecord *filerecord = [self.FilePathArray lastObject];
    [NewFolder setFolderID:[NSString stringWithFormat:@"%d",filerecord.fileid]];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    dispatch_after(0.1, dispatch_get_main_queue(), ^{
//        //这里跳转UI
//        [self.navigationController pushViewController:exm animated:NO];
//        //NSLog(@"%@",[NSThread currentThread]);
//    });
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:NewFolder];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:self];
}

-(void)sendStatuses:(HCStatuses *)Statuses{
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//创建TableView
-(void)createTableView{

    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) style:UITableViewStylePlain];
#pragma mark 设置代理和数据源
        _tableView.dataSource=self;
        _tableView.delegate=self;
#pragma mark 设置tableview的分割线
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
#pragma mark 设置无多余的分割线
//        _tableView.tableFooterView = [[UIView alloc] init];
        
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        _tableView.showsVerticalScrollIndicator=NO;//设置没有滚动条
        
#pragma mark 设置返回按钮
        self.navigationItem.title = [[NSString alloc]initWithFormat: @"%@",self.projectEntity.statuse.projectname];
        self.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *leftB = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(LeftAction:)];
            leftB;
        });
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName,nil] forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        

        [self.view addSubview:_tableView];
        self.view.backgroundColor = HCColor(55, 106, 133, 1);
    }
    [_tableView setTableHeaderView:[self headImageView]];
}

//拉伸顶部图片
-(void)lashenBgView{
    //图片的宽度设为屏幕的宽度，高度自适应
    _backgroundImgV.backgroundColor =HCColor(55, 106, 133, 1);
    [self.view addSubview:_backgroundImgV];
    _backImgHeight                         = _backgroundImgV.frame.size.height;
    _backImgWidth                          = _backgroundImgV.frame.size.width;
    _backImgOrgy                           = _backgroundImgV.frame.origin.y;
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_currentIndex>1) {
            return;
        }
        _currentIndex++;
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentIndex<=0) {
            return;
        }
        _currentIndex--;
    }
    [_headLineView setCurrentIndex:_currentIndex];
}

-(void)refreshHeadLine:(NSInteger)currentIndex IsClickAgain:(BOOL)flag
{
    _currentIndex=currentIndex;
    _flag = flag;
    self.FilesCellFrame = [SortWithResponse ResponseObjectWithArry:self.TemporaryArray andcurrentIndex:currentIndex andIsClickAgain:flag];
    [_tableView reloadData];
    if (_flag) {
        NSLog(@"第%ld个规则，正序",(long)_currentIndex);
    }else{
        NSLog(@"第%ld个规则，倒序",(long)_currentIndex);
    }
    //    [_tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headLineView) {
#pragma mark 设置返回路径
        UILabel *FilePath = [[UILabel alloc]init];
        FilePath.text = [self SetPath];
        FilePath.backgroundColor = HCColor(255, 255, 255, 0.5);
        FilePath.textColor = [UIColor whiteColor];
        FilePath.textAlignment = NSTextAlignmentLeft;
        self.FilePath = FilePath;
        self.FilePath.frame = CGRectMake(0, -30, self.view.w, 25);
        
        _headLineView=[[HeadLineView alloc]init];
        _headLineView.frame=CGRectMake(0, 0, UIScreenW, 38);
        _headLineView.delegate=self;
        [_headLineView setTitleArray:@[@"类型",@"名称",@"日期"]];
        [_headLineView addSubview:self.FilePath];
    }
    //如果headLineView需要添加图片，请到HeadLineView.m中去设置就可以了，里面有注释
    
    return _headLineView;
}


//头视图
-(UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView *headImageView=[[UIImageView alloc]init];
        headImageView.frame=CGRectMake(0, 20, UIScreenW, 60);
        headImageView.backgroundColor=[UIColor clearColor];
        _headImageView = headImageView;
    }
    return _headImageView;
}

#pragma mark 设置头部文件路径
-(NSString *)SetPath{
    NSString *Path = [[NSString alloc]initWithFormat:@"    项目目录：%@", self.projectEntity.statuse.projectname ];
    for (HCFilerecord *ST in self.FilePathArray) {
        NSString *name =[@"/" stringByAppendingString:ST.filename];
    Path           = [Path stringByAppendingString:name];
    };
    return Path;
}

#pragma mark 左边按钮事件
- (void)LeftAction:(UIBarButtonItem *)sender {
    HCLog(@"点击了返回按钮");
    sender.enabled = NO;
    self.view.userInteractionEnabled =NO;
    //先去除随后一位
    [self.FilePathArray removeLastObject];
    //从新设置目录路径
    self.FilePath.text = [self SetPath];
    //获取最后一位
    HCFilerecord *NewlastPath = [self.FilePathArray lastObject];
    //根目录flag（第一次）
    if ([self.FilePath.text isEqualToString:[[NSString alloc]initWithFormat:@"    项目目录：%@",self.projectEntity.statuse.projectname]]) {
        self.flag ++;
        //当一次来就会++变成2
        if (self.flag == 2) {
            sender.enabled = YES;
            self.view.userInteractionEnabled =YES;
//            [CYLPlusButtonSubclass registerPlusButton];
//            CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
//            self.view.window.rootViewController = tabBarControllerConfig.tabBarController;
////            self.view.window.rootViewController.navigationController.navigationBar.barTintColor = HCColor(44, 160, 249, 1);
//                UIViewController *viewController = [[HCHomeViewController alloc] init];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        else{
            [self OpenProjectWithProjectid:self.projectEntity.statuse.projectid];
            sender.enabled = YES;
        }
    }else{
        self.flag = 0;
        //        [LBProgressHUD showHUDto:self.view animated:YES];
        [HowardCityTool TimeOut:self];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *openUrl = [[NSString alloc]initWithFormat:@"%@action=getFilerecords&projectId=%@&folderId=%d&access_token=%@",HCInterfacePrefix,self.projectEntity.statuse.projectid,NewlastPath.fileid,self.account.access_token];
        [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *arry = [responseObject objectForKey:@"filerecordList"];
            self.FilesCellFrame = [SortWithResponse ResponseObjectWithArry:arry andcurrentIndex:0 andIsClickAgain:YES];
            //            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled =YES;
            sender.enabled = YES;
            [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            HCLog(@"请求失败%@",error);
            sender.enabled = YES;
            self.view.userInteractionEnabled =YES;
        }];
    };
}


#pragma mark -  3. 实现数据源（代理）方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FilesCellFrame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCFileCellFrame *cellFrame = self.FilesCellFrame[indexPath.row];
    return [cellFrame cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    HCFileCell *cell = [HCFileCell cellWithTabbleView:tableView];
    
    cell.FileCellFrm = self.FilesCellFrame[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    //判断是否过期
    if (![HowardCityTool TimeOut:self]) {
        self.flag = 0 ;
        self.view.userInteractionEnabled =NO;
        HCFileCell *cell = [[HCFileCell alloc]init];
        cell.FileCellFrm = self.FilesCellFrame[indexPath.row];
        //如果不是文件夹
        if (![cell.FileCellFrm.Filerecord.filetype isEqualToString:@"folder"]) {
            
            NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",cell.FileCellFrm.Filerecord.filename]];
            
            self.fileUrl = [NSURL fileURLWithPath:path];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:path]) //如果不存在
            {
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                HUD.label.text = @"文件正在下载，请稍后...";
                HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
                NSString *openUrl = [[NSString alloc]initWithFormat:@"%@action=downloadFile&recordId=%d&access_token=%@",HCInterfacePrefix,cell.FileCellFrm.Filerecord.fileid,self.account.access_token];
                // 1、 设置请求
                NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:openUrl]];
                // 2、初始化
                NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                // 3、开始下载
                NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 设置进度条的百分比
                        [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
                    });
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    return [NSURL fileURLWithPath:path];//转化为文件路径
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    [HowardCityTool TimeOut:self];
                    //下载成功
                    if (error == nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [HUD hideAnimated:NO];
                            //声明
                            if ([QLPreviewController canPreviewItem:(id<QLPreviewItem>)self.fileUrl]) {
                                if (UI_IS_IPHONE) {
                                    
                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
                                    
                                }
                                self.previewController = [QLPreviewController new];;
                                self.previewController.view.frame = CGRectMake(0, 64, UIScreenW, UIScreenH - 64);
                                self.previewController.delegate = self;
                                self.previewController.dataSource = self;
                                self.previewController.navigationController.navigationBar.userInteractionEnabled = YES;
                                self.previewController.view.userInteractionEnabled = YES;
                                [self presentViewController:self.previewController animated:NO completion:nil];
                            }
                        });
                        self.view.userInteractionEnabled =YES;
                        //如果请求没有错误(请求成功), 则打印地址
//                        self.Index = 2000;
                    }else{//下载失败的时候，只列举判断了两种错误状态码
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [HUD hideAnimated:NO];
                        });
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        
                        // Set the text mode to show only text.
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = NSLocalizedString(@"网络问题，请稍后重试", @"HUD message title");
                        if (error.code == - 1005) {
                            hud.label.text = NSLocalizedString(@"网络异常，请稍后重试", @"HUD message title");
                        }else if (error.code == -1001){
                            hud.label.text = NSLocalizedString(@"请求超时，请稍后重试", @"HUD message title");
                        }else{
                            hud.label.text = NSLocalizedString(@"未知错误，请稍后重试", @"HUD message title");
                        }
                        HCLog(@"%@", error);
                        [hud hideAnimated:YES afterDelay:1.f];
                        [fileManager removeItemAtPath:path error:NULL];
                        self.view.userInteractionEnabled = YES;
                    }
                }];
                [task resume];
                
            }else{
                self.view.userInteractionEnabled =YES;
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.label.text = @"本地文件正在打开";
                HUD.mode = MBProgressHUDModeCustomView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:NO];
                    //声明
                    if ([QLPreviewController canPreviewItem:(id<QLPreviewItem>)self.fileUrl]) {
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
                        self.previewController = [QLPreviewController new];
                        self.previewController.view.frame = CGRectMake(0, 64, UIScreenW, UIScreenH - 64);
                        self.previewController.delegate = self;
                        self.previewController.dataSource = self;
                        self.previewController.navigationController.navigationBar.userInteractionEnabled = YES;
                        self.previewController.view.userInteractionEnabled = YES;
                        [self presentViewController:self.previewController animated:NO completion:nil];
                    }
                });
                
//                self.Index = 2000;
            }
        }else{
//            self.Index = 2000;
            [self OpenFolderWithRecordid:cell];
        };
    }
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)OpenFolderWithRecordid:(HCFileCell *)cell{
//    [LBProgressHUD showHUDto:self.view animated:YES];
    self.view.userInteractionEnabled =NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *openUrl = [[NSString alloc]initWithFormat:@"%@action=getFilerecords&projectId=%@&folderId=%d&access_token=%@",HCInterfacePrefix,self.projectEntity.statuse.projectid,cell.FileCellFrm.Filerecord.fileid,self.account.access_token];
    
    [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSMutableArray *arry = [responseObject objectForKey:@"filerecordList"];
        self.TemporaryArray = arry;
        if ( arry.count == 0) {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            HUD.label.text = @"该文件夹下没有内容";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hideAnimated:YES afterDelay:1.f];
            //            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            self.Index = 2000;
            self.view.userInteractionEnabled =YES;
            [_tableView reloadData];
            self.flag ++;
            return;
        };
//        NSDate *startTime = [NSDate date];
        self.FilesCellFrame = [SortWithResponse ResponseObjectWithArry:arry andcurrentIndex:0 andIsClickAgain:YES];
//        HCLog(@"Time: %f", -[startTime timeIntervalSinceNow]);
        [self.FilePathArray addObject:cell.FileCellFrm.Filerecord];
        self.FilePath.text = [self SetPath];
        self.view.userInteractionEnabled =YES;
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.label.text = @"请求失败";
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD hideAnimated:YES afterDelay:1.f];
        self.view.userInteractionEnabled =YES;
//        [HUD showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//        } completionBlock:^{
//            [HUD removeFromSuperview];
//        }];
        HCLog(@"请求失败%@",error);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    HCLog(@"%d",contentOffsety);
    if (contentOffsety<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-contentOffsety;
        rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
//        CGPoint offset = scrollView.contentOffset;
//        offset.y = 0;
//        scrollView.contentOffset = offset;
        
    }
    
}

-(void)OpenProjectWithProjectid:(NSString *)projectid{
    if (![HowardCityTool TimeOut:self]) {
        self.view.userInteractionEnabled =NO;
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *openUrl = [[NSString alloc]initWithFormat:@"%@action=getFilerecords&projectId=%@&folderId=0&access_token=%@",HCInterfacePrefix,projectid,self.account.access_token];
        [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *arry = [responseObject objectForKey:@"filerecordList"];
            self.TemporaryArray = arry;
            if (arry.count == 0) {
                //            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.label.text = @"该工程尚未开始";
                HUD.mode = MBProgressHUDModeCustomView;
                [HUD hideAnimated:YES afterDelay:1.f];
                self.view.userInteractionEnabled =YES;
                return;
            };
            self.FilesCellFrame = [SortWithResponse ResponseObjectWithArry:arry andcurrentIndex:0 andIsClickAgain:YES];
            //        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_tableView reloadData];
            self.view.userInteractionEnabled =YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.label.text = @"请求失败";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled =YES;
            HCLog(@"请求失败%@",error);
        }];
    };
}

#pragma mark - QLPreviewController 代理方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    HCLog(@"%@",self.fileUrl);
    return self.fileUrl;
}

//-(void)didReceiveMemoryWarning
//
//{
//    
//    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
//    
//    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
//    
//    if ([self.view window] == nil)// 是否是正在使用的视图
//        
//    {
//        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
//        
//    }
//    
//}

#pragma mark 监听屏幕的旋转 ，ios8以前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    HCLog(@"屏幕转了");
    NSMutableArray *cellFrmsM = [NSMutableArray array];
    for (HCFileCellFrame *object in self.FilesCellFrame) {
        HCFileCellFrame *cellFrm = [[HCFileCellFrame alloc] init];
        cellFrm.Filerecord = object.Filerecord;
        [cellFrmsM addObject:cellFrm];
    };
    self.FilesCellFrame = cellFrmsM;
    [_tableView reloadData];
}

- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            [UIView animateWithDuration:0.25 animations:^{
                self.previewController.view.transform = CGAffineTransformMakeRotation(0);
                self.previewController.view.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [UIView animateWithDuration:0.25 animations:^{
                self.previewController.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                self.previewController.view.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [UIView animateWithDuration:0.25 animations:^{
                self.previewController.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
                self.previewController.view.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller

{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

@end

