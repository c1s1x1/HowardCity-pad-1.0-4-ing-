//
//  KSStringMatching.h
//  TemplateLayoutCellTest
//
//  Created by Kwok_Sir on 15/7/27.
//  Copyright (c) 2015年 Fung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMatchingResult : NSObject

/**
 * 匹配的结果范围
 */
@property(nonatomic,assign)NSRange range;

/**
 * 匹配结果后截取的字符串
 */
@property(nonatomic,copy)NSString *cutStrs;

@property(nonatomic,copy)NSString *matchType;

+(instancetype)result;

@end


@interface KSStringMatching : NSObject


+(instancetype)defaultMatching;

/**
 * 匹配的的标识类型
 * 此类型会添加到KSMatchingResult的matchType属性
 */
@property(nonatomic,copy)NSString *matchType;

/**
 * 是否需要截取匹配后的字符串放入数组中,默认会帮你截取
 */
@property(nonatomic,assign,getter=isNoNeedCutStrs)BOOL noNeedCutStrs;



/**
 * 根据正则表达式 匹配结果，返回KSMatchingResult 的数组
 * @param string 被匹配的字符串
 * @param pattern 正则表达试
 */
-(NSArray *)matchString:(NSString *)string pattern:(NSString *)pattern;


/**
 * 通过正则表达式拆分字符串,返回不匹配正则表达式的结果
 */
-(NSArray *)separatedString:(NSString *)string pattern:(NSString *)pattern;
@end
