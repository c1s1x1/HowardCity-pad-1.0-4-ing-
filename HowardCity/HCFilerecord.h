//
//  HCFilerecord.h
//  
//
//  Created by CSX on 16/4/21.
//
//

#import <Foundation/Foundation.h>

@interface HCFilerecord : NSObject

//文件编号
@property(nonatomic,assign)int fileid;
//文件类型
@property(nonatomic,copy)NSString *filetype;
//文件名
@property(nonatomic,copy)NSString *filename;
//文件路径
@property(nonatomic,copy)NSURL *filepath;
//文件地址
@property(nonatomic,copy)NSURL *thumbnailPath;
//文件地址
@property(nonatomic,assign)long long size;
//文件创建日期
@property(nonatomic,copy)NSString *createTime;

@end