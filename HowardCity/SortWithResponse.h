//
//  SortWithResponse.h
//  HowardCity
//
//  Created by CSX on 2016/12/7.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortWithResponse : NSObject

+(NSMutableArray *)ResponseObjectWithArry:(NSMutableArray *)array andcurrentIndex:(NSInteger)currentIndex andIsClickAgain:(BOOL)flag;

@end
