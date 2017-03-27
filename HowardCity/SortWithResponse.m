//
//  SortWithResponse.m
//  HowardCity
//
//  Created by CSX on 2016/12/7.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import "SortWithResponse.h"
#import "HCFileCellFrame.h"
#import "MJExtension.h"
#import "NSString+ChineseCharactersToSpelling.h"

@implementation SortWithResponse


/**
 * @brief 传入响应返回的数组，按规则进行排序.
 *
 * @param  array 响应返回的数组.
 * @param  currentIndex 排序按钮的tag.
 * @param  flag 升降序判断条件.
 *
 * @return 返回排好序的数组.
 *
 * @bug 缺陷: 参数未经过为空判断，有可能崩溃.
 */
+(NSMutableArray *)ResponseObjectWithArry:(NSMutableArray *)array andcurrentIndex:(NSInteger)currentIndex andIsClickAgain:(BOOL)flag{
    NSMutableArray *FoldercellFrmsM = [NSMutableArray array];
    NSMutableArray *FileCellFrmsM = [NSMutableArray array];
   
    for (id object in array) {
        HCFileCellFrame *cellFrm = [[HCFileCellFrame alloc] init];
        //把字典放入模型里
        HCFilerecord *File = [HCFilerecord objectWithKeyValues:object];
        cellFrm.Filerecord = File;
        if (currentIndex == 0) {
            if ([cellFrm.Filerecord.filetype isEqualToString:@"folder"]) {
                [FoldercellFrmsM addObject:cellFrm];
            }else{
                [FileCellFrmsM addObject:cellFrm];
            }
        }else{
            [FoldercellFrmsM addObject:cellFrm];
        }
    };
    NSDate *startTime = [NSDate date];
//    int a;
    //文件夹组
    if (FoldercellFrmsM.count != 0) {
        for(NSUInteger i = 0; i < FoldercellFrmsM.count - 1; i++) {
            for(NSUInteger j = 0; j < FoldercellFrmsM.count - i - 1; j++) {
                HCFileCellFrame *FileFirst = FoldercellFrmsM[j];
                HCFileCellFrame *FileSecond = FoldercellFrmsM[j + 1];
                NSString *pinyinFirst;
                NSString *pinyinSecond;
                switch (currentIndex)
                {
                    case 0:
                        pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filetype];
                        pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filetype];
                        break;
                        
                    case 1:
                        pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filename];
                        pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filename];
                        break;
    
                    case 2:
                        pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.createTime];
                        pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.createTime];
                        break;
                }
                
                //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                //升序排列
                if (flag) {
                    if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                        HCFileCellFrame *tempString = FoldercellFrmsM[j];
                        FoldercellFrmsM[j] = FoldercellFrmsM[j + 1];
                        FoldercellFrmsM[j + 1] = tempString;
                    }
                }
                //降序排列
                else{
                    if(NSOrderedAscending == [pinyinFirst compare:pinyinSecond]) {
                        HCFileCellFrame *tempString = FoldercellFrmsM[j];
                        FoldercellFrmsM[j] = FoldercellFrmsM[j + 1];
                        FoldercellFrmsM[j + 1] = tempString;
                    }
                }
            }
        };
        HCLog(@"1~~~~~~~~Time: %f", -[startTime timeIntervalSinceNow]);
        if (currentIndex == 0) {
//            while (a > 0) {
//                a = 0;
                for(NSUInteger i = 0; i < FoldercellFrmsM.count - 1; i++) {
                    for(NSUInteger j = 0; j < FoldercellFrmsM.count - i - 1; j++) {
                        HCFileCellFrame *FileFirst = FoldercellFrmsM[j];
                        HCFileCellFrame *FileSecond = FoldercellFrmsM[j + 1];
//                        NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filetype];
//                        NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filetype];
                        NSString *First = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filename];
                        NSString *Second = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filename];
                        
                        //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                        //升序排列
                        if (flag) {
//                            if(NSOrderedSame == [pinyinFirst compare:pinyinSecond]) {
                                if(NSOrderedDescending == [First compare:Second]) {
                                    HCFileCellFrame *tempString = FoldercellFrmsM[j];
                                    FoldercellFrmsM[j] = FoldercellFrmsM[j + 1];
                                    FoldercellFrmsM[j + 1] = tempString;
//                                    a ++;
                                }
//                            }else {
//                                break;
//                            }
                        }
                        //降序排列
                        else{
//                            if(NSOrderedSame == [pinyinFirst compare:pinyinSecond]) {
                                if(NSOrderedAscending == [First compare:Second]) {
                                    HCFileCellFrame *tempString = FoldercellFrmsM[j];
                                    FoldercellFrmsM[j] = FoldercellFrmsM[j + 1];
                                    FoldercellFrmsM[j + 1] = tempString;
//                                    a ++;
                                }
//                            }else {
//                                break;
//                            }
                        }
                    }
                };
//            };
//            HCLog(@"2~~~~~~~~Time: %f", -[startTime timeIntervalSinceNow]);
        };
    };
    //文件组
    if (FileCellFrmsM.count != 0) {
        for(NSUInteger i = 0; i < FileCellFrmsM.count - 1; i++) {
            for(NSUInteger j = 0; j < FileCellFrmsM.count - i - 1; j++) {
                HCFileCellFrame *FileFirst = FileCellFrmsM[j];
                HCFileCellFrame *FileSecond = FileCellFrmsM[j + 1];
                NSString *pinyinFirst;
                NSString *pinyinSecond;
                switch (currentIndex)
                {
                    case 0:
                        pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filetype];
                        pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filetype];
                        break;
                        
                    case 1:
                        pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filename];
                        pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filename];
                        break;
                        
                    case 2:
                        pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.createTime];
                        pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.createTime];
                        break;
                }
                //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                //升序排列
                if (flag) {
                    if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                        HCFileCellFrame *tempString = FileCellFrmsM[j];
                        FileCellFrmsM[j] = FileCellFrmsM[j + 1];
                        FileCellFrmsM[j + 1] = tempString;
                    }
                }
                //降序排列
                else{
                    if(NSOrderedAscending == [pinyinFirst compare:pinyinSecond]) {
                        HCFileCellFrame *tempString = FileCellFrmsM[j];
                        FileCellFrmsM[j] = FileCellFrmsM[j + 1];
                        FileCellFrmsM[j + 1] = tempString;
                    }
                }
            }
        };
//        if (currentIndex == 0) {
////            while (a > 0) {
////                a = 0;
//                for(NSUInteger i = 0; i < FileCellFrmsM.count - 1; i++) {
//                    for(NSUInteger j = 0; j < FileCellFrmsM.count - i - 1; j++) {
//                        HCFileCellFrame *FileFirst = FileCellFrmsM[j];
//                        HCFileCellFrame *FileSecond = FileCellFrmsM[j + 1];
//                        NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filetype];
//                        NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filetype];
//                        NSString *First = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.filename];
//                        NSString *Second = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.filename];
//                        
//                        //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
//                        //升序排列
//                        if (flag) {
//                            if(NSOrderedSame == [pinyinFirst compare:pinyinSecond]) {
//                                if(NSOrderedDescending == [First compare:Second]) {
//                                    HCFileCellFrame *tempString = FileCellFrmsM[j];
//                                    FileCellFrmsM[j] = FileCellFrmsM[j + 1];
//                                    FileCellFrmsM[j + 1] = tempString;
//                                    a ++;
//                                }
//                            }else {
//                                break;
//                            }
//                        }
//                        //降序排列
//                        else{
//                            if(NSOrderedSame == [pinyinFirst compare:pinyinSecond]) {
//                                if(NSOrderedAscending == [First compare:Second]) {
//                                    HCFileCellFrame *tempString = FileCellFrmsM[j];
//                                    FileCellFrmsM[j] = FileCellFrmsM[j + 1];
//                                    FileCellFrmsM[j + 1] = tempString;
//                                    a ++;
//                                }
//                            }else {
//                                break;
//                            }
//                        }
//                    }
//                };
////            };
//        };

    };
    if (currentIndex == 0) {
        if (flag) {
            [FoldercellFrmsM addObjectsFromArray:FileCellFrmsM];
        }else{
            [FileCellFrmsM addObjectsFromArray:FoldercellFrmsM];
            FoldercellFrmsM = FileCellFrmsM;
        }
    }
//    if (flag) {
    return FoldercellFrmsM;
//    }else{
//        return FileCellFrmsM;
//    }
    
}

@end
