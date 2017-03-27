//
//  TreeTableView.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Node;
@class HCFilerecord;

@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (Node *)node withFilerecord : (HCFilerecord *)CFilerecord;

@end

@interface TreeTableView : UITableView

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data withFilerecord : (NSArray *)Filerecord;

@end
