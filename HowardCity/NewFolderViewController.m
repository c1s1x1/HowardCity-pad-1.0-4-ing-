//
//  NewFolderViewController.m
//  HowardCity
//
//  Created by CSX on 2017/2/28.
//  Copyright © 2017年 CSX. All rights reserved.
//

#import "NewFolderViewController.h"
#import "STPopup/STPopup.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface NewFolderViewController ()<TZImagePickerControllerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}


@property(nonatomic,strong)HCAccount *account;

@end


@implementation NewFolderViewController
{
    UIView *_label;
    UIView *_separatorView;
    UIView *_textField;
    UIButton *_Abutton;
    UIButton *_Bbutton;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"上传";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (HCAccount *)account{
    if (!_account) {
        _account = [HCAuthTool user];
    }
    return _account;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HCLog(@"%@%@",self.projectID,self.FolderID);
    
    //    self.view.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:0.5];
    //
    //    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    //    effectview.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Image" style:UIBarButtonItemStylePlain target:self action:@selector(pushImagePickerController)];
    //    [UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:1.0];
    _label = [UIView new];
    _Abutton = [UIButton new];
    _Abutton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [_Abutton setTitleColor:[UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _Abutton.layer.cornerRadius = 10;
    _Abutton.layer.shadowOpacity = 0.3;// 阴影透明度
    _Abutton.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    _Abutton.layer.shadowRadius = 2;// 阴影扩散的范围控制
    _Abutton.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    [_Abutton setImage:[UIImage imageNamed:@"图片"]forState:UIControlStateNormal];
    [_Abutton addTarget:self action:@selector(pushImagePickerController) forControlEvents:UIControlEventTouchUpInside];
    [_label addSubview:_Abutton];
    _label.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:1];
    [self.view addSubview:_label];
    
    _textField = [UIView new];
    _Bbutton = [UIButton new];
    _Bbutton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [_Bbutton setTitleColor:[UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _Bbutton.layer.cornerRadius = 10;
    _Bbutton.layer.shadowOpacity = 0.3;// 阴影透明度
    _Bbutton.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    _Bbutton.layer.shadowRadius = 2;// 阴影扩散的范围控制
    _Bbutton.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    [_Bbutton setImage:[UIImage imageNamed:@"视频"]forState:UIControlStateNormal];
    [_Bbutton addTarget:self action:@selector(pushVideoPickerController) forControlEvents:UIControlEventTouchUpInside];
    [_textField addSubview:_Bbutton];
    _textField.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:106.0/255.0 blue:133.0/255.0 alpha:1];
    [self.view addSubview:_textField];
    
    //    [self.view addSubview:effectview];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _Abutton.frame = CGRectMake(self.view.frame.size.width/2 - 30, self.view.frame.size.height/4 - 30,60, 60);
    _Bbutton.frame = CGRectMake(self.view.frame.size.width/2 - 30, self.view.frame.size.height/4 - 30,60, 60);
    _label.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height /2);
    _textField.frame = CGRectMake(0, self.view.frame.size.height/2 + 1, self.view.frame.size.width, self.view.frame.size.height /2 -0.5);
    //    _separatorView.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 0.5);
    
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.maxImagesCount = 4;
    imagePickerVc.allowTakePicture = YES;
#pragma mark - 到这里为止
    
//    // You can get the photos by block, the same as by delegate.
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        
//    }];
//    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerController

- (void)pushVideoPickerController {
    
    TZImagePickerController *VideoPickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    VideoPickerVc.allowPickingVideo = YES;
    VideoPickerVc.allowPickingImage = NO;
    VideoPickerVc.maxImagesCount = 1;
    VideoPickerVc.allowTakePicture = NO;
#pragma mark - 到这里为止
    
//    // You can get the photos by block, the same as by delegate.
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [VideoPickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        
//    }];
    
    [self presentViewController:VideoPickerVc animated:YES completion:nil];
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    // 1.打印图片名字
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    paramDict[@"projectId"] = self.projectID;
    paramDict[@"folderId"] = self.FolderID;
    paramDict[@"filenum"] = [NSString stringWithFormat:@"%ld",[photos count]];
    paramDict[@"access_token"] = self.account.access_token;
    NSMutableArray *imagename = [self printAssetsName:assets];
    NSMutableArray *imagedd = [NSMutableArray array];
    int i = 1;
    for (UIImage *image in photos) {
        NSData *imageData;
        imageData = UIImageJPEGRepresentation(image, 0.3f);
        NSString *strBase64 = [imageData base64EncodedStringWithOptions:0];
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//        NSString *rawString=[[NSString alloc]initWithData:imageData encoding:enc];
        paramDict[[NSString stringWithFormat:@"filename%d",i]] = [imagename objectAtIndex:i - 1];
        [imagedd addObject:imageData];
//        paramDict[[NSString stringWithFormat:@"filedatas%d",i]] = rawString;
        i++;
    }
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"https://www.rovibim.cn:8443/androidside.jsp?action=MuploadFile"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
////    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
////        if (error) {
////            NSLog(@"Error: %@", error);
////        } else {
////            NSLog(@"Success: %@ %@", response, responseObject);
////        }
////    }];
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:[imagedd objectAtIndex:0] progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//    }];
//    [uploadTask resume];
//
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject:响应体信息
     第六个参数:失败回调
     */
   
    //2.上传文件
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    HUD.label.text = @"图片正在上传，请稍后...";
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    HCLog(@"%@",[imagedd objectAtIndex:0]);
    [manager POST:@"https://www.rovibim.cn:8443/MFile.action" parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
//         NSInputStream *input = [NSInputStream inputStreamWithData:videoData];
        [formData appendPartWithFileData:[imagedd objectAtIndex:0] name:@"file" fileName:[imagename objectAtIndex:0] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            HUD.progress = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        });
        HCLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HUD hideAnimated:NO];
        HCLog(@"上传成功---%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"上传失败---%@",error);
    }];
}

/// 打印图片名字
- (NSMutableArray *)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    NSString *duration;
    NSMutableArray *imagename = [NSMutableArray array];
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            duration = [phAsset valueForKey:@"duration"];
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        [imagename addObject:fileName];
    }
    return imagename;
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    // open this code to send video / 打开这段代码发送视频
    __weak UIViewController *weakSelf = self;
    MBProgressHUD *HUDVideo = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    HUDVideo.label.text = @"视频正在上传，请稍后...";
    HUDVideo.mode = MBProgressHUDModeDeterminateHorizontalBar;
     [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
     NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//     Export completed, send video here, send by outputPath or NSData
//     导出完成，在这里写上传代码，通过路径或者通过NSData上传
//         NSData *video = [NSData dataWithContentsOfFile:outputPath];
         PHAsset *phAsset = (PHAsset *)asset;
         NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
         paramDict[@"projectId"] = self.projectID;
         paramDict[@"folderId"] = self.FolderID;
         paramDict[@"filedatas  "] = [NSData dataWithContentsOfFile:outputPath];
         paramDict[@"filename"] = [phAsset valueForKey:@"filename"];
         paramDict[@"access_token"] = self.account.access_token;
        
         //1.创建会话管理者
         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
         
         //    NSDictionary *dictM = @{}
         //2.发送post请求上传文件
         /*
          第一个参数:请求路径
          第二个参数:字典(非文件参数)
          第三个参数:constructingBodyWithBlock 处理要上传的文件数据
          第四个参数:进度回调
          第五个参数:成功回调 responseObject:响应体信息
          第六个参数:失败回调
          */
         
         //2.上传文件
         manager.responseSerializer = [AFHTTPResponseSerializer serializer];
         
         [manager POST:@"https://www.rovibim.cn:8443/androidside.jsp?action=MediaUpload" parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             //使用formData来拼接数据
             /*
              第一个参数:二进制数据 要上传的文件参数
              第二个参数:服务器规定的
              第三个参数:该文件上传到服务器以什么名称保存
              */
             //         NSInputStream *input = [NSInputStream inputStreamWithData:videoData];
         } progress:^(NSProgress * _Nonnull uploadProgress) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 设置进度条的百分比
                 [MBProgressHUD HUDForView:weakSelf.view].progress = 1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
             });
             HCLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [HUDVideo hideAnimated:NO];
             HCLog(@"上传成功---%@",responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             HCLog(@"上传失败---%@",error);
         }];
     }];
//    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    // 1.打印图片名字
//    [self printAssetsName:asset];
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
//    [_collectionView reloadData];
}

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */

//+ (void)startMultiPartUploadTaskWithURL:(NSString *)url
//                            imagesArray:(NSArray *)images
//                      parameterOfimages:(NSString *)parameter
//                         parametersDict:(NSDictionary *)parameters
//                       compressionRatio:(float)ratio
//{
//    
//    //    if (images.count == 0) {
//    //        NSLog(@"上传内容没有包含图片");
//    //        return;
//    //    }
//    for (int i = 0; i < images.count; i++) {
//        if (![images[i] isKindOfClass:[UIImage class]]) {
//            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
//            return;
//        }
//    }
//    AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer]; // 申明返回的结果是json类型
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [operation POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        int i = 1;
//        //根据当前系统时间生成图片名称
//        //        NSDate *date = [NSDate date];
//        //        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        //        [formatter setDateFormat:@"yyyy年MM月dd日"];
//        //        NSString *dateString = [formatter stringFromDate:date];
//        
//        for (UIImage *image in images) {
//            NSString *fileName = [NSString stringWithFormat:@"image%d.png",i];
//            NSString * nameStr = [NSString stringWithFormat:@"%@%d",parameter, i];
//            NSData *imageData;
//            if (ratio > 0.0f && ratio < 1.0f) {
//                imageData = UIImageJPEGRepresentation(image, ratio);
//            }else{
//                imageData = UIImageJPEGRepresentation(image, 1.0f);
//            }
//            
//            [formData appendPartWithFileData:imageData name:nameStr fileName:fileName mimeType:@"image/jpeg"];
//            i++;
//        }
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        
//        
//    }];
//    
//}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) { // take photo / 去拍照
//        [self takePhoto];
//    } else if (buttonIndex == 1) {
//        [self pushImagePickerController];
//    }
//}
//
//#pragma mark - UIImagePickerController
//
//- (void)takePhoto {
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
//        // 无相机权限 做一个友好的提示
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//        // 拍照之前还需要检查相册权限
//    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        alert.tag = 1;
//        [alert show];
//    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            return [self takePhoto];
//        });
//    } else { // 调用相机
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//            self.imagePickerVc.sourceType = sourceType;
//            if(iOS8Later) {
//                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            }
//            [self presentViewController:_imagePickerVc animated:YES completion:nil];
//        } else {
//            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
//        }
//    }
//}

//#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
//        if (iOS8Later) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        } else {
//            NSURL *privacyUrl;
//            if (alertView.tag == 1) {
//                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
//            } else {
//                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
//            }
//            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
//                [[UIApplication sharedApplication] openURL:privacyUrl];
//            } else {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }
//        }
//    }
//}


@end
