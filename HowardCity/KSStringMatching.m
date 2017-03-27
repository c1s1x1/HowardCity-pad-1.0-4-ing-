//
//  KSStringMatching.m
//  TemplateLayoutCellTest
//
//  Created by Vincent_Guo on 15/7/27.
//  Copyright (c) 2015年 Fung. All rights reserved.
//

#import "KSStringMatching.h"
#define KSLog(...) NSLog(@"%s %d\n %@\n\n",__func__,__LINE__ ,[NSString stringWithFormat:__VA_ARGS__])

@implementation KSMatchingResult

+(instancetype)result{
    return [[self alloc] init];
}

@end


static KSStringMatching *matching;

@implementation KSStringMatching


+(instancetype)defaultMatching{
 
    if (!matching) {
        matching = [[self alloc] init];
    }
    
    return matching;
}

-(NSArray *)matchString:(NSString *)string pattern:(NSString *)pattern{
    


    NSError *error = nil;
    NSRegularExpression *expresion = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        KSLog(@"%@",error);
    }
    
    NSArray *results = [expresion matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];

    // 遍历匹配结果
    NSMutableArray *mResultM = [NSMutableArray array];
    for (NSTextCheckingResult *textResult in results) {
        KSMatchingResult *mResult = [[KSMatchingResult alloc] init];
        mResult.range = textResult.range;
        if (self.isNoNeedCutStrs == NO) {
            mResult.cutStrs = [string substringWithRange:textResult.range];
        }
        
        if (self.matchType) {
            mResult.matchType = self.matchType;
        }
        
        [mResultM addObject:mResult];
    }
    
    return [mResultM copy];
}

-(NSArray *)separatedString:(NSString *)string pattern:(NSString *)pattern{

    // 1.匹配成功的结果
    NSArray *matchResults = [self matchString:string pattern:pattern];
    
    
    
    // AA#a#a#abc#
    // 2,3
    // 6,5
    
    // 2.未匹配成功的结果
    NSMutableArray *nonResultsM = [NSMutableArray array];
    
    
    if (matchResults.count == 0) {
        KSMatchingResult *nonResult = [KSMatchingResult result];
        nonResult.range = NSMakeRange(0,string.length);
        if (self.isNoNeedCutStrs == NO){
            nonResult.cutStrs = [string substringWithRange:nonResult.range];
        }
        nonResult.matchType = self.matchType;
        [nonResultsM addObject:nonResult];
    }
    
    
    [matchResults enumerateObjectsUsingBlock:^(KSMatchingResult *mResult, NSUInteger idx, BOOL *stop) {
        // 第一个
        if (idx == 0) {
            if (mResult.range.location != 0) {
                KSMatchingResult *nonResult = [KSMatchingResult result];
                nonResult.range = NSMakeRange(0, mResult.range.location);
                if (self.isNoNeedCutStrs == NO){
                    nonResult.cutStrs = [string substringWithRange:nonResult.range];
                }
                nonResult.matchType = self.matchType;
                [nonResultsM addObject:nonResult];
            }
            return;
        }
        
        
        
        // 第2个以上
        if (idx > 0) {
            // 上一个结果
            KSMatchingResult *previousResult = matchResults[idx - 1];
            
            // 上一个结果结束的字符串位置
            NSUInteger endPositionOfPrevious = previousResult.range.location + previousResult.range.length;
            if (mResult.range.location != endPositionOfPrevious) {
                KSMatchingResult *nonResult = [KSMatchingResult result];
                nonResult.range = NSMakeRange(endPositionOfPrevious, mResult.range.location - endPositionOfPrevious);
                if (self.isNoNeedCutStrs == NO){
                    nonResult.cutStrs = [string substringWithRange:nonResult.range];
                }
                nonResult.matchType = self.matchType;
                [nonResultsM addObject:nonResult];
            }
        }
        
        // 最后一个
        if (idx == matchResults.count - 1) {
            NSUInteger endPosition = mResult.range.location + mResult.range.length;
            if (endPosition != string.length) {
                KSMatchingResult *nonResult = [KSMatchingResult result];
                nonResult.range = NSMakeRange(endPosition, string.length - endPosition);
                if (self.isNoNeedCutStrs == NO){
                    nonResult.cutStrs = [string substringWithRange:nonResult.range];
                }
                nonResult.matchType = self.matchType;
                [nonResultsM addObject:nonResult];
            }
        }
    }];
    
    return [nonResultsM copy];
}


@end
