//
//  PublishTaskViewController.m
//  HowardCity
//
//  Created by CSX on 2017/2/13.
//  Copyright © 2017年 CSX. All rights reserved.
//

#import "PublishTaskViewController.h"
#import <QuickLook/QuickLook.h>
#import "XLForm.h"
#import "HCUserInfo.h"
#import "DateAndTimeValueTrasformer.h"

//@implementation NativeEventNavigationViewController
//
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self.view setTintColor:[UIColor redColor]];
//}
//
//@end

@interface PublishTaskViewController ()

@property(nonatomic,strong)HCAccount *account;

@property(nonatomic,strong)NSMutableDictionary *TaskDetailed;

@property(nonatomic,strong)NSURL *fileUrl;

@property(nonatomic,strong) QLPreviewController *previewController;

@property (nonatomic, strong) HCUserInfo *UserInfo;

@property (nonatomic, strong) NSMutableArray *taskarry;

@end

@implementation PublishTaskViewController

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

- (NSMutableArray *)taskarry{

    if (!_taskarry) {
        _taskarry = [NSMutableArray array];
    }
    return  _taskarry;
}

- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"任务详情"];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"任务名称"];
    [form addFormSection:section];
    
#pragma mark 任务名称
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"TaskName" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"任务名称" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
//    // Starts
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"starts" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"起始时间"];
//    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
//    [section addFormRow:row];
    
#pragma mark 截止日期
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ends" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"截止时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
#pragma mark 选择项目
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Project" rowType:XLFormRowDescriptorTypeSelectorPush title:@"选择项目"];
    row.selectorTitle = @"拥有的项目工程";
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:self.account.projectID.count];
    int i= 0;
    NSString *projectname = @"";
    for (id key in self.account.projectID) {
        HCStatuses *stat = [self.account.projectID objectForKey:key];
        [arry addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(i) displayText:[NSString stringWithFormat:@"%@",stat.projectname]]];
        if (i==0) {
            projectname = stat.projectname;
        }
        i++;
    }
    row.value = projectname;
    row.selectorOptions = arry;
    [section addFormRow:row];
    
#pragma mark 执行人员
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ProjectUser" rowType:XLFormRowDescriptorTypeMultipleSelector title:@"执行人员"];
    NSArray *Initial = [self.TaskDetailed objectForKey:projectname];
    NSMutableArray *ProjectUserArry = [NSMutableArray array];
    int j = 0;
    for (HCUserInfo *user in Initial) {
        [ProjectUserArry addObject:user.username];
        if (j==0) {
            row.value = @[user.username];
        }
        j++;
    }
    row.selectorOptions = ProjectUserArry;
    [section addFormRow:row];
    
#pragma mark 知会人员
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ProjectMessageUser" rowType:XLFormRowDescriptorTypeMultipleSelector title:@"知会人员"];
    NSMutableArray *ProjectMessageUserArry = [NSMutableArray array];
    for (HCUserInfo *user in Initial) {
        [ProjectMessageUserArry addObject:user.username];
    }
    row.selectorOptions = ProjectMessageUserArry;
    [section addFormRow:row];

#pragma mark 任务类型
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"TaskType" rowType:XLFormRowDescriptorTypeSelectorPush title:@"任务类型"];
    row.selectorTitle = @"任务类型";
    row.value = @"普通任务";
    row.selectorOptions = self.taskarry;
    [section addFormRow:row];
    
#pragma mark 任务附件
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"任务附件" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"任务附件"];
    NSMutableArray *arr1y = [NSMutableArray arrayWithCapacity:1];;
    [arr1y addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@""]];
    row.selectorOptions = arr1y;
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"选择附件"];
    [section addFormRow:row];
    
#pragma mark 任务详情
    section = [XLFormSectionDescriptor formSectionWithTitle:@"任务详情"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"taskInfomation" rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"任务详情" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
#pragma mark 发布按钮
    section = [XLFormSectionDescriptor formSectionWithTitle:@" "];
    [form addFormSection:section];
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"button" rowType:XLFormRowDescriptorTypeButton title:@"发布"];
    buttonRow.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:buttonRow];
    
    self.form = form;
}

-(void)didTouchButton:(XLFormRowDescriptor *)sender{
    XLFormRowDescriptor * TaskNameDescriptor = [self.form formRowWithTag:@"TaskName"];
//    XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
    XLFormRowDescriptor * endsDateDescriptor = [self.form formRowWithTag:@"ends"];
    XLFormRowDescriptor * ProjectDescriptor = [self.form formRowWithTag:@"Project"];
    XLFormRowDescriptor * ProjectUserDescriptor = [self.form formRowWithTag:@"ProjectUser"];
    XLFormRowDescriptor * ProjectMessageUserDescriptor = [self.form formRowWithTag:@"ProjectMessageUser"];
    XLFormRowDescriptor * TaskTypeDescriptor = [self.form formRowWithTag:@"TaskType"];
    XLFormRowDescriptor * taskInfomationDescriptor = [self.form formRowWithTag:@"taskInfomation"];
    
#pragma mark 项目id获取
    NSString *projectID = @"";
    for (id key in self.account.projectID) {
        HCStatuses *stat = [self.account.projectID objectForKey:key];
        if ([stat.projectname isEqualToString:ProjectDescriptor.displayTextValue]) {
            projectID = stat.projectid;
            break;
        }
    }
    
    if (TaskNameDescriptor.displayTextValue.length == 0) {
        [self HUDWithTitle:@"任务名称不能为空"];
        [self deselectFormRow:sender];
        HCLog(@"任务名称不能为空");
        return;
    }
    
#pragma mark 截止时间获取处理
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* Date = [inputFormatter stringFromDate:endsDateDescriptor.value];
    Date = [Date stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSTimeInterval interval = [endsDateDescriptor.value timeIntervalSinceNow];
//    HCLog(@"%f",interval);
    if (interval < 0) {
        [self HUDWithTitle:@"截止时间不能低于当前时间"];
        [self deselectFormRow:sender];
        HCLog(@"截止时间不能低于当前时间");
        return;
    }
    
#pragma mark 执行人id获取处理
    NSMutableString *ProjectUserID = [NSMutableString string];
    NSString *ProjectUserIDS = [[NSString alloc]init];
    if ([ProjectUserDescriptor.value count]!=0) {
        NSArray *Initial = [self.TaskDetailed objectForKey:ProjectDescriptor.displayTextValue];
        for (NSString *username in ProjectUserDescriptor.value) {
            for (HCUserInfo *user in Initial) {
                if ([user.username isEqualToString:username]) {
                    [ProjectUserID appendString:[NSString stringWithFormat:@"%@,",user.userid]];
                }
            }
        }
       ProjectUserIDS = [ProjectUserID substringToIndex:[ProjectUserID length] - 1];
    }else{
        [self HUDWithTitle:@"执行不允许为空"];
        [self deselectFormRow:sender];
        HCLog(@"执行不允许为空");
        return;
    }
    
    
#pragma mark 知会人id获取处理
    NSMutableString *ProjectMessageUserID = [NSMutableString string];
    NSString *ProjectMessageUserIDS = [[NSString alloc]init];
    if ([ProjectMessageUserDescriptor.value count]!= 0 ) {
        NSArray *Initial = [self.TaskDetailed objectForKey:ProjectDescriptor.displayTextValue];
        for (NSString *username in ProjectMessageUserDescriptor.value) {
            for (HCUserInfo *user in Initial) {
                if ([user.username isEqualToString:username]) {
                    [ProjectMessageUserID appendString:[NSString stringWithFormat:@"%@,",user.userid]];
                }
            }
        }
        ProjectMessageUserIDS = [ProjectMessageUserID substringToIndex:[ProjectMessageUserID length] - 1];
    }else{
        ProjectMessageUserIDS = @"";
    }
    
    NSString *taskInfomationDescriptorS = [[NSString alloc]init];
    if ([taskInfomationDescriptor.value  length] == 0) {
        taskInfomationDescriptorS = @"";
    }else{
        taskInfomationDescriptorS = [taskInfomationDescriptor.value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    HCLog(@"%@",taskInfomationDescriptorS);
//    HCLog(@"projectId=%@\ntaskName=%@\ndeadlinetext=%@\ntaskType=%@\ndescriptiontext=%@\ndoingpersonid=%@\nnotifypersonid=%@\naccess_token=%@\n项目名称:%@",projectID,TaskNameDescriptor.displayTextValue,Date,TaskTypeDescriptor.displayTextValue,taskInfomationDescriptor.displayTextValue,ProjectUserID,ProjectMessageUserID,self.account.access_token,ProjectDescriptor.displayTextValue);
    
    if (![HowardCityTool TimeOut:self]) {
        self.view.userInteractionEnabled = NO;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        HUD.label.text =NSLocalizedString(@"Loading...", @"HUD loading title");
        // Set the details label text. Let's make it multiline this time.
        HUD.detailsLabel.text = NSLocalizedString(@"正在发布任务...", @"HUD title");
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        NSString *TaskNameDescriptorS = [TaskNameDescriptor.displayTextValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//        taskInfomationDescriptorS =
        NSString *TaskTypeDescriptorS =[TaskTypeDescriptor.displayTextValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=addTask&projectId=%@&taskName=%@&deadlinetext=%@&taskType=%@&descriptiontext=%@&doingpersonid=%@&notifypersonid=%@&access_token=%@",HCInterfacePrefix,projectID,TaskNameDescriptorS,Date,TaskTypeDescriptorS,taskInfomationDescriptorS,ProjectUserIDS,ProjectMessageUserIDS,self.account.access_token];
//        LoginUrl = [LoginUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [NSCharacterSet URLHostAllowedCharacterSet];
        
#pragma mark 拼接url
        HCLog(@"%@",LoginUrl);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[[responseObject objectForKey:@"result"]stringValue] isEqualToString:@"0"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:YES];
                    self.view.userInteractionEnabled = YES;
                    [self deselectFormRow:sender];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:YES];
                });
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Set the text mode to show only text.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"发布失败，请稍后重试", @"HUD message title");
                [hud hideAnimated:YES afterDelay:1.f];
                self.view.userInteractionEnabled = YES;
                [self deselectFormRow:sender];
                return;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            HCLog(@"请求失败%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
            });
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            
            if (error.code == - 1005) {
                hud.label.text = NSLocalizedString(@"网络异常", @"HUD message title");
            }else if (error.code == -1001){
                hud.label.text = NSLocalizedString(@"请求超时", @"HUD message title");
            }else{
                hud.label.text = [[NSString alloc]initWithFormat:@"未知错误%ld",error.code];
            }
            [hud hideAnimated:YES afterDelay:1.f];
            self.view.userInteractionEnabled = YES;
            [self deselectFormRow:sender];
            return;
        }];
    }
}

-(void)HUDWithTitle:(NSString *)Title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(Title, @"HUD message title");
    [hud hideAnimated:YES afterDelay:1.f];
}

// 每个cell内部的参数属性更改了就会调用这个方法，我们再次更新的话就会调用cell里面update的方法进行重绘
- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    // 咱们这里统一调用更新
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    [self updateFormRow:rowDescriptor];
    
    //     以下就是一些典型的tag判断，根据不同的cell，remove 或 update进行更改
    if ([rowDescriptor.tag isEqualToString:@"Project"]){
        HCLog(@"%@",rowDescriptor.displayTextValue);
#pragma mark 动态改变执行人员
        XLFormRowDescriptor * ProjectUserRow = [self.form formRowWithTag:@"ProjectUser"];
        NSArray *ProjectUserInitial = [self.TaskDetailed objectForKey:rowDescriptor.displayTextValue];
        NSMutableArray *ProjectUserArry = [NSMutableArray array];
        int i = 0;
        for (HCUserInfo *user in ProjectUserInitial) {
            [ProjectUserArry addObject:user.username];
            if (i==0) {
                ProjectUserRow.value = @[user.username];
            }
            i++;
        }
        ProjectUserRow.selectorOptions = ProjectUserArry;
#pragma mark 动态改变知会人员
        XLFormRowDescriptor * ProjectMessageUserRow = [self.form formRowWithTag:@"ProjectMessageUser"];
        NSArray *ProjectMessageUserInitial = [self.TaskDetailed objectForKey:rowDescriptor.displayTextValue];
        NSMutableArray *ProjectMessageUserArry = [NSMutableArray array];
        int j = 0;
        for (HCUserInfo *user in ProjectMessageUserInitial) {
            [ProjectMessageUserArry addObject:user.username];
            j++;
        }
        ProjectMessageUserRow.selectorOptions = ProjectUserArry;
        [self updateFormRow:ProjectUserRow];
        [self updateFormRow:ProjectMessageUserRow];
    }
//    else if ([rowDescriptor.tag isEqualToString:@"all-day"]){
//        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
//        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
//        XLFormDateCell * dateStartCell = (XLFormDateCell *)[[self.form formRowWithTag:@"starts"] cellForFormController:self];
//        XLFormDateCell * dateEndCell = (XLFormDateCell *)[[self.form formRowWithTag:@"ends"] cellForFormController:self];
//        if ([[rowDescriptor.value valueData] boolValue] == YES){
//            startDateDescriptor.valueTransformer = [DateValueTrasformer class];
//            endDateDescriptor.valueTransformer = [DateValueTrasformer class];
//            [dateStartCell setFormDatePickerMode:XLFormDateDatePickerModeDate];
//            [dateEndCell setFormDatePickerMode:XLFormDateDatePickerModeDate];
//        }
//        else{
//            startDateDescriptor.valueTransformer = [DateTimeValueTrasformer class];
//            endDateDescriptor.valueTransformer = [DateTimeValueTrasformer class];
//            [dateStartCell setFormDatePickerMode:XLFormDateDatePickerModeDateTime];
//            [dateEndCell setFormDatePickerMode:XLFormDateDatePickerModeDateTime];
//        }
//        [self updateFormRow:startDateDescriptor];
//        [self updateFormRow:endDateDescriptor];
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
    else if ([rowDescriptor.tag isEqualToString:@"ends"]){
//        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
        XLFormDateCell * dateEndCell = (XLFormDateCell *)[endDateDescriptor cellForFormController:self];
        if ([endDateDescriptor.value timeIntervalSinceNow] < 0) {
            // startDateDescriptor is later than endDateDescriptor
            [dateEndCell update]; // force detailTextLabel update
            NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:@1
                                                                               forKey:NSStrikethroughStyleAttributeName];
            NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:dateEndCell.detailTextLabel.text attributes:strikeThroughAttribute];
            [endDateDescriptor.cellConfig setObject:strikeThroughText forKey:@"detailTextLabel.attributedText"];
            [self updateFormRow:endDateDescriptor];
        }
        else{
            [endDateDescriptor.cellConfig removeObjectForKey:@"detailTextLabel.attributedText"];
            [self updateFormRow:endDateDescriptor];
        }
    }
    if ([rowDescriptor.tag isEqualToString:@"任务附件"]){
        NSObject *id = rowDescriptor.value;
        NSString *fileName = id.displayText;
        NSLog(@"点击了%@的任务附件",fileName);
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        HUD.label.text = @"任务附件下载尚未开放";
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD hideAnimated:YES afterDelay:1.f];
#pragma mark 年后开放
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



-(void)initDate{
    if (![HowardCityTool TimeOut:self]) {
        self.view.userInteractionEnabled = NO;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        HUD.label.text =NSLocalizedString(@"Loading...", @"HUD loading title");
        // Set the details label text. Let's make it multiline this time.
        HUD.detailsLabel.text = NSLocalizedString(@"正在获取最新项目相关人员...", @"HUD title");
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        NSMutableString *projectid =[[NSMutableString alloc] init];
        NSString *access_token =self.account.access_token;
        for (id key in self.account.projectID) {
            [projectid appendString:[NSString stringWithFormat:@"%@,",key]];
        };
        NSString *projectId = [projectid substringToIndex:[projectid length] - 1];
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=getuserlist&projectId=%@&access_token=%@",HCInterfacePrefix,projectId,access_token];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *arry = [responseObject objectForKey:@"userList"];
            NSMutableDictionary *taskD = [NSMutableDictionary dictionary];
            NSMutableArray *arryf = [[NSMutableArray alloc]init];
            
            for (id key in self.account.projectID) {
                int i = 0;
                for (id object in arry) {
                    
                    HCUserInfo *UserInfoN = [HCUserInfo objectWithKeyValues:object];
                    if ([UserInfoN.projectid isEqualToString:key]) {
                        [arryf addObject:UserInfoN];
                        i ++ ;
                    }
                }
                HCStatuses *stat = [self.account.projectID objectForKey:key];
                NSArray *flag = [NSArray arrayWithArray:arryf];
                [taskD setValue:flag forKey:[NSString stringWithFormat:@"%@",stat.projectname]];
                [arryf removeAllObjects];
            }
            HCLog(@"%@",taskD);
            self.TaskDetailed = taskD;
            [HUD hideAnimated:YES afterDelay:0.f];
            [self TaskType];
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

-(void)TaskType{
    if (![HowardCityTool TimeOut:self]) {
        self.view.userInteractionEnabled = NO;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        HUD.label.text =NSLocalizedString(@"Loading...", @"HUD loading title");
        // Set the details label text. Let's make it multiline this time.
        HUD.detailsLabel.text = NSLocalizedString(@"正在获取最新任务类型...", @"HUD title");
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        NSString *access_token =self.account.access_token;
        NSString *LoginUrl = [[NSString alloc]initWithFormat:@"%@action=gettasktypelist&access_token=%@",HCInterfacePrefix,access_token];
#pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            HCLog(@"等待模式开启~~~~~~~~~~~~~~");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                [MBProgressHUD HUDForView:self.view].progress = downloadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *arry = [responseObject objectForKey:@"tasktypeList"];
            NSMutableArray *taskarry = [NSMutableArray array];
            int i = 0;
            for (id object in arry) {
                NSString *tasktypename = [object objectForKey:@"tasktypename"];
                [taskarry addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(i) displayText:tasktypename]];
                i ++ ;
            }
            [HUD hideAnimated:YES afterDelay:0.f];
            self.taskarry = taskarry;
            self.view.userInteractionEnabled = YES;
            [self loadingData:YES];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//-(void)viewDidDisappear:(BOOL)animated{
//    self.hidesBottomBarWhenPushed=NO;
//}

-(void)LeftAction:(UIBarButtonItem *)sender{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
