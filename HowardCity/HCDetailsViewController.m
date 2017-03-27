//
//  CYLDetailsViewController.m
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "HCDetailsViewController.h"
#import "CYLTabBarController.h"
#import "XLForm.h"
#import <QuickLook/QuickLook.h>

@interface HCDetailsViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property(nonatomic,strong)HCAccount *account;

@property(nonatomic,strong)NSMutableDictionary *Attachment;

@property(nonatomic,strong)NSURL *fileUrl;

@property(nonatomic,strong) QLPreviewController *previewController;

@end

@implementation HCDetailsViewController

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"任务详情"];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"任务信息"];
    [form addFormSection:section];
    
    //任务名称
    XLFormRowDescriptor *tasknameRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"taskname" rowType:XLFormRowDescriptorTypeInfo];
    tasknameRowDescriptor.title = @"任务名称";
    tasknameRowDescriptor.value = self.Task.taskname;
    [section addFormRow:tasknameRowDescriptor];
    
    //任务所属项目名称
    XLFormRowDescriptor *projectnameRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"projectname" rowType:XLFormRowDescriptorTypeInfo];
    projectnameRowDescriptor.title = @"任务所属项目名称";
    projectnameRowDescriptor.value = self.Task.projectname;
    [section addFormRow:projectnameRowDescriptor];
    
    //发布者
    XLFormRowDescriptor *usernameRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"username" rowType:XLFormRowDescriptorTypeInfo];
    usernameRowDescriptor.title = @"发布者";
    usernameRowDescriptor.value = self.Task.username;
    [section addFormRow:usernameRowDescriptor];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    //任务类型
    XLFormRowDescriptor *tasktypeRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"tasktype" rowType:XLFormRowDescriptorTypeInfo];
    tasktypeRowDescriptor.title = @"任务类型";
    tasktypeRowDescriptor.value = self.Task.tasktype;
    [section addFormRow:tasktypeRowDescriptor];
    
    //发布日期
    XLFormRowDescriptor *buildtimeRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"buildtime" rowType:XLFormRowDescriptorTypeInfo];
    buildtimeRowDescriptor.title = @"发布日期";
    buildtimeRowDescriptor.value = self.Task.buildtime;
    [section addFormRow:buildtimeRowDescriptor];
    
    //截止期限
    XLFormRowDescriptor *deadlineRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"deadlinetext" rowType:XLFormRowDescriptorTypeInfo];
    deadlineRowDescriptor.title = @"截止期限";
    deadlineRowDescriptor.value = self.Task.deadlinetext;
    [section addFormRow:deadlineRowDescriptor];
    
    //任务状态
    XLFormRowDescriptor *taskstateRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"taskstate" rowType:XLFormRowDescriptorTypeInfo];
    taskstateRowDescriptor.title = @"任务状态";
    switch ([self.Task.taskstate intValue])
    {
        case 0:
            taskstateRowDescriptor.value = @"正常";
            break;
            
        case 1:
            taskstateRowDescriptor.value = @"失效";
            break;
            
        case 2:
            taskstateRowDescriptor.value = @"完成";
            break;
    }
    [section addFormRow:taskstateRowDescriptor];
    
    //用户任务执行状态
    XLFormRowDescriptor *hoperationsRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"hoperations" rowType:XLFormRowDescriptorTypeInfo];
    hoperationsRowDescriptor.title = @"用户任务执行状态";
    switch ([self.Task.hoperations intValue])
    {
        case 0:
            hoperationsRowDescriptor.value = @"未阅读";
            break;
            
        case 1:
            hoperationsRowDescriptor.value = @"已阅读";
            break;
            
        case 2:
            hoperationsRowDescriptor.value = @"等待审核";
            break;
            
        case 3:
            hoperationsRowDescriptor.value = @"审核通过";
            break;
            
        case 4:
            hoperationsRowDescriptor.value = @"审核不通过";
            break;
            
        case 5:
            hoperationsRowDescriptor.value = @"过期";
            break;
    }
    [section addFormRow:hoperationsRowDescriptor];
    
    //执行/审核
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"执行/审核" rowType:XLFormRowDescriptorTypeSelectorPush title:@"执行"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@""];
    row.selectorTitle = @"审核";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"此功能尚未开放"]
                            ];
    [section addFormRow:row];
    
    //任务附件
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"任务附件" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"任务附件"];
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:1];
    [arry addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:self.Task.recordname]];
    row.selectorOptions = arry;
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"选择附件"];
    [section addFormRow:row];
    
    //任务详情
    section = [XLFormSectionDescriptor formSectionWithTitle:@"任务详情"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"任务详情" forKey:@"textView.placeholder"];
    row.value = self.Task.descriptiontext;
    row.disabled = @YES;
    [section addFormRow:row];
    
    self.form = form;
}


// 每个cell内部的参数属性更改了就会调用这个方法，我们再次更新的话就会调用cell里面update的方法进行重绘
- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    // 咱们这里统一调用更新
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    [self updateFormRow:formRow];
    
    
//     以下就是一些典型的tag判断，根据不同的cell，remove 或 update进行更改
        if ([formRow.tag isEqualToString:@"任务附件"]){
            NSObject *id = formRow.value;
            NSString *fileName = id.displayText;
            NSLog(@"点击了%@的任务附件",fileName);
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            HUD.label.text = @"任务附件下载尚未开放";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hideAnimated:YES afterDelay:1.f];
#pragma mark 年后开放
//            //判断是否过期
//            if (![HowardCityTool TimeOut:self]) {
//                //如果不是文件夹
//                
//                    NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
//                    
//                    self.fileUrl = [NSURL fileURLWithPath:path];
//                    
//                    NSFileManager *fileManager = [NSFileManager defaultManager];
//                    
//                    if(![fileManager fileExistsAtPath:path]) //如果不存在
//                    {
//                        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//                        HUD.label.text = @"文件正在下载，请稍后...";
//                        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
//                        // 1、 设置请求
//                        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.Task.recordpath]];
//                        // 2、初始化
//                        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//                        AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//                        // 3、开始下载
//                        NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                // 设置进度条的百分比
//                                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
//                            });
//                        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                            return [NSURL fileURLWithPath:path];//转化为文件路径
//                        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                            [HowardCityTool TimeOut:self];
//                            //下载成功
//                            if (error == nil) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [HUD hideAnimated:YES];
//                                    //声明
//                                    if ([QLPreviewController canPreviewItem:[NSURL fileURLWithPath:path]] ) {
//                                        if (UI_IS_IPHONE) {
//                                            
//                                            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
//                                            
//                                        }
//                                        self.previewController = [QLPreviewController new];;
//                                        self.previewController.view.frame = CGRectMake(0, 64, UIScreenW, UIScreenH - 64);
//                                        self.previewController.delegate = self;
//                                        self.previewController.dataSource = self;
//                                        self.previewController.navigationController.navigationBar.userInteractionEnabled = YES;
//                                        self.previewController.view.userInteractionEnabled = YES;
//                                        [self presentViewController:self.previewController animated:NO completion:nil];
//                                    }
//                                });
//                                self.view.userInteractionEnabled =YES;
//                                //如果请求没有错误(请求成功), 则打印地址
//                            }else{//下载失败的时候，只列举判断了两种错误状态码
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [HUD hideAnimated:NO];
//                                });
//                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                                
//                                // Set the text mode to show only text.
//                                hud.mode = MBProgressHUDModeText;
//                                hud.label.text = NSLocalizedString(@"网络问题，请稍后重试", @"HUD message title");
//                                if (error.code == - 1005) {
//                                    hud.label.text = NSLocalizedString(@"网络异常，请稍后重试", @"HUD message title");
//                                }else if (error.code == -1001){
//                                    hud.label.text = NSLocalizedString(@"请求超时，请稍后重试", @"HUD message title");
//                                }else{
//                                    hud.label.text = NSLocalizedString(@"未知错误，请稍后重试", @"HUD message title");
//                                }
//                                HCLog(@"%@", error);
//                                [hud hideAnimated:YES afterDelay:1.f];
//                                [fileManager removeItemAtPath:path error:NULL];
//                                self.view.userInteractionEnabled = YES;
//                            }
//                        }];
//                        [task resume];
//                        
//                    }else{
////                        self.view.userInteractionEnabled =YES;
////                        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
////                        [self.view addSubview:HUD];
////                        HUD.label.text = @"本地文件正在打开";
////                        HUD.mode = MBProgressHUDModeCustomView;
////                        dispatch_async(dispatch_get_main_queue(), ^{
////                            [HUD hideAnimated:NO];
////                            //声明
////                            if ([QLPreviewController canPreviewItem:(id<QLPreviewItem>)self.fileUrl]) {
////                                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
////                                self.previewController = [QLPreviewController new];
////                                self.previewController.view.frame = CGRectMake(0, 64, UIScreenW, UIScreenH - 64);
////                                self.previewController.delegate = self;
////                                self.previewController.dataSource = self;
////                                self.previewController.navigationController.navigationBar.userInteractionEnabled = YES;
////                                self.previewController.view.userInteractionEnabled = YES;
////                                [self presentViewController:self.previewController animated:NO completion:nil];
////                            }
////                        });
//                        
//                        //                self.Index = 2000;
//                    }
//                
//            }
        }
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
#pragma mark 设置返回按钮
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *leftB = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(LeftAction:)];
        leftB;
    });
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self initDate];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)LeftAction:(UIBarButtonItem *)sender{


    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)initDate{
    if (![HowardCityTool TimeOut:self]) {
        self.view.userInteractionEnabled = NO;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        HUD.label.text =NSLocalizedString(@"Loading...", @"HUD loading title");
        // Set the details label text. Let's make it multiline this time.
        HUD.detailsLabel.text = NSLocalizedString(@"正在加载项目...", @"HUD title");
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        int isdoing;
        if (![self.Task.taskform isEqualToString:@"执行"]) {
            isdoing = 1;
        }
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=getTaskInfo&taskId=%@&isdoing=%d&access_token=%@",HCInterfacePrefix,self.Task.taskid,isdoing,self.account.access_token];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            HCTask *Task = [HCTask objectWithKeyValues:responseObject];
            Task.recordpath = [responseObject objectForKey:@"recordpath"];
            if (Task == nil) {
                [self loadingData:NO];
                [HUD hideAnimated:YES];
                return ;
            }
            self.Task = Task;
            [HUD hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled = YES;
            [self loadingData:YES];
//            NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=getUserTaskList&taskId=%@&access_token=%@",HCInterfacePrefix,self.Task.taskid,self.account.access_token];
//#pragma mark 拼接url
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
//                HCLog(@"等待模式开启~~~~~~~~~~~~~~");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // 设置进度条的百分比
//                    [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
//                });
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                HCTask *Task = [HCTask objectWithKeyValues:responseObject];
//                Task.recordpath = [responseObject objectForKey:@"usertaskList"];
//                if (Task == nil) {
//                    [self loadingData:NO];
//                    [HUD hideAnimated:YES];
//                    return ;
//                }
//                self.Task = Task;
//                [HUD hideAnimated:YES afterDelay:1.f];
//                self.view.userInteractionEnabled = YES;
//                [self loadingData:YES];
//                [self initializeForm];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                HCLog(@"请求失败%@",error);
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                
//                // Set the text mode to show only text.
//                hud.mode = MBProgressHUDModeText;
//                
//                if (error.code == - 1005) {
//                    hud.label.text = NSLocalizedString(@"网络异常,稍后自动重试", @"HUD message title");
//                }else if (error.code == -1001){
//                    hud.label.text = NSLocalizedString(@"请求超时,稍后自动重试", @"HUD message title");
//                }else{
//                    hud.label.text = [[NSString alloc]initWithFormat:@"未知错误%ld,稍后自动重试",error.code];
//                }
//                [hud hideAnimated:YES afterDelay:3.f];
//                self.view.userInteractionEnabled = YES;
//                [self loadingData:NO];
//                [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initDate) userInfo:nil repeats:NO];
//            }];
            [self initializeForm];
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
    if (data) {
        self.tableView.loading = YES;
    }else {// 无数据时
        self.tableView.loading = NO;
    }
    [self.tableView reloadData];
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

#pragma mark - QLPreviewController 代理方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    HCLog(@"%@",self.fileUrl);
    return self.fileUrl;
}


#pragma mark - XLFormDescriptorDelegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        //        if (tableView == self.tableView) {
//        CGFloat cornerRadius = 10.f;
//        cell.backgroundColor = [UIColor clearColor];
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
//        BOOL addLine = NO;
//        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//        } else if (indexPath.row == 0) {
//            
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//            addLine = YES;
//            
//        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//        } else {
//            CGPathAddRect(pathRef, nil, bounds);
//            addLine = YES;
//        }
//        layer.path = pathRef;
//        CFRelease(pathRef);
//        //颜色修改
//        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
//        layer.strokeColor=[UIColor blackColor].CGColor;
//        if (addLine == YES) {
//            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
//            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//            [layer addSublayer:lineLayer];
//        }
//        UIView *testView = [[UIView alloc] initWithFrame:bounds];
//        [testView.layer insertSublayer:layer atIndex:0];
//        testView.backgroundColor = [UIColor whiteColor];
//        cell.backgroundView = testView;
//    }
//}

//-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
//{
//    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
//    if ([rowDescriptor.tag isEqualToString:@"alert"]){
//        if ([[rowDescriptor.value valueData] isEqualToNumber:@(0)] == NO && [[oldValue valueData] isEqualToNumber:@(0)]){
//            
//            XLFormRowDescriptor * newRow = [rowDescriptor copy];
//            newRow.tag = @"secondAlert";
//            newRow.title = @"Second Alert";
//            [self.form addFormRow:newRow afterRow:rowDescriptor];
//        }
//        else if ([[oldValue valueData] isEqualToNumber:@(0)] == NO && [[newValue valueData] isEqualToNumber:@(0)]){
//            [self.form removeFormRowWithTag:@"secondAlert"];
//        }
//    }
//    else if ([rowDescriptor.tag isEqualToString:@"all-day"]){
////        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
////        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
////        XLFormDateCell * dateStartCell = (XLFormDateCell *)[[self.form formRowWithTag:@"starts"] cellForFormController:self];
////        XLFormDateCell * dateEndCell = (XLFormDateCell *)[[self.form formRowWithTag:@"ends"] cellForFormController:self];
////        if ([[rowDescriptor.value valueData] boolValue] == YES){
////            startDateDescriptor.valueTransformer = [DateValueTrasformer class];
////            endDateDescriptor.valueTransformer = [DateValueTrasformer class];
////            [dateStartCell setFormDatePickerMode:XLFormDateDatePickerModeDate];
////            [dateEndCell setFormDatePickerMode:XLFormDateDatePickerModeDate];
////        }
////        else{
////            startDateDescriptor.valueTransformer = [DateTimeValueTrasformer class];
////            endDateDescriptor.valueTransformer = [DateTimeValueTrasformer class];
////            [dateStartCell setFormDatePickerMode:XLFormDateDatePickerModeDateTime];
////            [dateEndCell setFormDatePickerMode:XLFormDateDatePickerModeDateTime];
////        }
////        [self updateFormRow:startDateDescriptor];
////        [self updateFormRow:endDateDescriptor];
//    }
//    else if ([rowDescriptor.tag isEqualToString:@"starts"]){
//        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
//        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
//        if ([startDateDescriptor.value compare:endDateDescriptor.value] == NSOrderedDescending) {
//            // startDateDescriptor is later than endDateDescriptor
//            endDateDescriptor.value =  [[NSDate alloc] initWithTimeInterval:(60*60*24) sinceDate:startDateDescriptor.value];
//            [endDateDescriptor.cellConfig removeObjectForKey:@"detailTextLabel.attributedText"];
//            [self updateFormRow:endDateDescriptor];
//        }
//    }
//    else if ([rowDescriptor.tag isEqualToString:@"ends"]){
//        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
//        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
//        XLFormDateCell * dateEndCell = (XLFormDateCell *)[endDateDescriptor cellForFormController:self];
//        if ([startDateDescriptor.value compare:endDateDescriptor.value] == NSOrderedDescending) {
//            // startDateDescriptor is later than endDateDescriptor
//            [dateEndCell update]; // force detailTextLabel update
//            NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:@1
//                                                                               forKey:NSStrikethroughStyleAttributeName];
//            NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:dateEndCell.detailTextLabel.text attributes:strikeThroughAttribute];
//            [endDateDescriptor.cellConfig setObject:strikeThroughText forKey:@"detailTextLabel.attributedText"];
//            [self updateFormRow:endDateDescriptor];
//        }
//        else{
//            [endDateDescriptor.cellConfig removeObjectForKey:@"detailTextLabel.attributedText"];
//            [self updateFormRow:endDateDescriptor];
//        }
//    }
//}

//-(void)cancelPressed:(UIBarButtonItem * __unused)button
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


//-(void)savePressed:(UIBarButtonItem * __unused)button
//{
//    NSArray * validationErrors = [self formValidationErrors];
//    if (validationErrors.count > 0){
//        [self showFormValidationError:[validationErrors firstObject]];
//        return;
//    }
//    [self.tableView endEditing:YES];
//}

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self){
//        [self initializeForm];
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self){
//        [self initializeForm];
//    }
//    return self;
//}
//
//- (void)initializeForm {
//    // Implementation details covered in the next section.
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.title = @"详情页";
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"点击屏幕可跳转到“我的”，执行testPush";
//    label.frame = CGRectMake(20, 150, CGRectGetWidth(self.view.frame) - 2 * 20, 20);
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self cyl_popSelectTabBarChildViewControllerAtIndex:3 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//        HCMineViewController *mineViewController = selectedTabBarChildViewController;
//        [mineViewController testPush];
//    }];
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
//
//#pragma mark - Table view
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return 183.f;
//    }
//    return 44.f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    if (indexPath.row == 0) {
//
//        return cell;
//    }
//    NSString *CellThree = @"CellThree";
//    // 设置tableview类型
//    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellThree];
//    // 设置不可点击
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.imageView.image = [UIImage imageNamed:@"mycity_highlight"];// 图片
////    NSArray *key = [self.UserInfoArry allKeys];
////    NSArray *values = [self.UserInfoArry allValues];
////    cell.textLabel.text = key[indexPath.row -1];// 文本
////    cell.detailTextLabel.text = values[indexPath.row -1];// 子文本
//    //    [self configureCell:cell forIndexPath:indexPath];
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 11;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", @(indexPath.row + 1)]];
//}

@end
