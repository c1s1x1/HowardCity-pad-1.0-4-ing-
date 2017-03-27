#import <Foundation/Foundation.h>

@interface HCStatuses : NSObject



//项目编号
@property(nonatomic,copy)NSString *projectid;
//项目名称
@property(nonatomic,copy)NSString *projectname;
//项目信息
@property(nonatomic,copy)NSString *information;
//图片
@property(nonatomic,copy)NSURL *projectImgPath;
//项目CPI
@property(nonatomic,assign)double cpi;
//项目SPI
@property(nonatomic,assign)double spi;
//项目CVI
@property(nonatomic,assign)double cv;
//项目SVI
@property(nonatomic,assign)double sv;
//创建者
@property(nonatomic,copy)NSString *username;
//创建时间
@property(nonatomic,copy)NSString *buildtime;
//人数
@property(nonatomic,assign)double peoplesum;
//项目空间容量大小
@property(nonatomic,assign)double space;
//项目已占用空间容量大小
@property(nonatomic,assign)double occupation;

@end