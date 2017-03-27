//
//  HCNotice.h
//  
//
//  Created by CSX on 16/4/21.
//
//

#import <Foundation/Foundation.h>

@interface HCNotice : NSObject


//通知发送者
@property(nonatomic,copy)NSString *sender;
//通知ID
@property(nonatomic,copy)NSString *infoid;
//通知类型
@property(nonatomic,copy)NSString *infoType;
//通知标题
@property(nonatomic,copy)NSString *title;
//通知发送时间
@property(nonatomic,copy)NSString *sendTime;
//通知详情
@property(nonatomic,copy)NSString *describe;
//通知是否阅读状态
@property(nonatomic,copy)NSString *Isvisit;

////是否过期
//@property(nonatomic,assign)BOOL tokenTimeOut;

@end