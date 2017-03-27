//
//  HCPublish.h
//  
//
//  Created by CSX on 16/4/21.
//
//

#import <Foundation/Foundation.h>

@interface HCTask : NSObject
/**
 *  任务状态（固定）
 */
@property (nonatomic,copy) NSString                    *taskform;
/**
 *  任务ID
 */
@property (nonatomic,copy) NSString                    *taskid;
/**
 *  任务名称
 */
@property (nonatomic,copy) NSString                    *taskname;
/**
 *  任务发布者
 */
@property (nonatomic,copy) NSString                    *username;
/**
 *  截止日期
 */
@property (nonatomic,copy) NSString                    *deadlinetext;
/**
 *  任务创建时间
 */
@property (nonatomic,copy) NSString                    *buildtime;
/**
 *  任务类型
 */
@property (nonatomic,copy) NSString                    *tasktype;
/**
 *  任务描述
 */
@property (nonatomic,copy) NSString                    *descriptiontext;
/**
 *  任务状态
 0-正常状态；
 1-失效状态；
 2-完成状态；(结束任务)
 */
@property (nonatomic,copy) NSString                    *taskstate;
/**
 *  任务所属的项目名称
 */
@property (nonatomic,copy) NSString                    *projectname;
/**
 *  任务附件名
 */
@property (nonatomic,copy) NSString                    *recordname;
/**
 *  任务附件URL
 */
@property (nonatomic,copy) NSURL                       *recordpath;
/**
 *  用户任务执行状态
 0-未阅读
 1-已阅读
 2-等待审核
 3-审核通过
 4-审核不通过
 5-已过期限，过期
 */
@property (nonatomic,copy) NSString                    *hoperations;

////是否过期
//@property(nonatomic,assign)BOOL tokenTimeOut;

@end