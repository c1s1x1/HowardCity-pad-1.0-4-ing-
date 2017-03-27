//
//  UserTask.h
//  HowardCity
//
//  Created by CSX on 2017/1/20.
//  Copyright © 2017年 CSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTask : NSObject

/**
 *  任务状态（固定）
 */
@property (nonatomic,copy) NSString                    *username;
/**
 *  任务ID
 */
@property (nonatomic,copy) NSString                    *userimg;
/**
 *  任务名称
 */
@property (nonatomic,copy) NSString                    *taskname;


@end
