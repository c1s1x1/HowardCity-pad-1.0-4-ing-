//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "Node.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UIView+CZ.h"
#import "HCFilerecord.h"

@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）

@property (nonatomic , strong) NSMutableArray *FilerecordS;//模型数组


@end

@implementation TreeTableView

-(instancetype)initWithFrame:(CGRect)frame withData : (NSMutableArray *)data withFilerecord : (NSMutableArray *)FilerecordS{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _data = data;
        _FilerecordS = FilerecordS;
        _tempData = [self createTempData:data];
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSMutableArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    Node *node = [_tempData objectAtIndex:indexPath.row];
    
//    HCFilerecord *Filerecord = [_FilerecordS objectAtIndex:indexPath.row];
    
//    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [iconButton setFrame:CGRectMake(node.depth * 30.f, 5, 30, 30)];
//    HCLog(@"%@\n%d\n%@\n%@\n%@",node.name,node.depth,Filerecord.name,Filerecord.kind,NSStringFromCGRect(iconButton.frame));
//    [iconButton setAdjustsImageWhenHighlighted:NO];
//    if ([Filerecord.kind isEqualToString:@"folder"]) {
//        [iconButton setImage:[UIImage imageNamed:@"item-icon-folder-selected"] forState:UIControlStateNormal];
//        [cell.imageView addSubview:iconButton];
//    };
//
    if (node.depth == 0) {
        cell.imageView.image = [UIImage imageNamed:@"item-icon-folder-selected"];
        
    }
    // cell有缩进的方法
    cell.indentationLevel = node.depth; // 缩进级别
    cell.indentationWidth = 40.f; // 每个缩进级别的距离
    
    cell.textLabel.text = node.name;
    
    cell.textLabel.font = HCFileFont;
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.selectedBackgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    
    
    
    
    return cell;
}


#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCFilerecord *Filerecord = [_FilerecordS objectAtIndex:indexPath.row];
    
#pragma mark 拼接url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *openUrl = [[NSString alloc]initWithFormat:@"http://rovit.wicp.net/androidside.jsp?action=openfile&recordid=%d",Filerecord.recordid];

    //获取项目数据
    [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //先修改数据源
        Node *parentNode = [_tempData objectAtIndex:indexPath.row];
        if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:withFilerecord:)]) {
            [_treeTableCellDelegate cellClick:parentNode withFilerecord:Filerecord];
        }
        
        
        //设置删除功能的起始点和结束点
        NSUInteger DeletestartPosition = 1;
        NSUInteger DeleteendPosition = 0;
        BOOL expand = NO;
        
        //筛选深度小于点击节点的cell
        for (int i=0; i<_data.count; i++) {
            Node *NextNode = [_data objectAtIndex:i];
            if (NextNode.depth > parentNode.depth) {
                DeletestartPosition = i-1;
                Node *node = [_data objectAtIndex:DeletestartPosition];
                DeleteendPosition = [self removeAllNodesAtParentNode:node];
                break;
            }
        }
        
        [self beginUpdates];
        
        //删除节点
        if (DeleteendPosition != 0) {
            //获得需要修正的indexPath
            NSMutableArray *DeleteindexPathArray = [NSMutableArray array];
            for (NSUInteger i=DeletestartPosition+1; i<DeleteendPosition+1; i++) {
                NSIndexPath *DeletetempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [DeleteindexPathArray addObject:DeletetempIndexPath];
            }
            [self deleteRowsAtIndexPaths:DeleteindexPathArray withRowAnimation:UITableViewRowAnimationNone];
        };
        [self endUpdates];

        //不为空才添加
        if (responseObject == NULL) {
            return ;
        };
        NSMutableArray *FilerecordS = [[NSMutableArray alloc]init];
        NSMutableArray *NodeS = [[NSMutableArray alloc]init];
        NSMutableArray *arry = responseObject;
        int i = 0 ;
        for (id object in arry) {
            NSString *name = object;
            NSDictionary *tool = responseObject[name];
            HCFilerecord *Filerecord = [HCFilerecord objectWithKeyValues:tool];
            Node *province = [[Node alloc] initWithParentId:parentNode.nodeId nodeId:parentNode.nodeId + 1 + i name:Filerecord.name depth:parentNode.depth + 1 expand:NO];
            [NodeS addObject:province];
            [FilerecordS addObject:Filerecord];
            i = i + 1;
        }
        
        
        //设置添加功能的起始点和结束点
        NSUInteger startPosition = indexPath.row + 1;
        NSUInteger endPosition = startPosition;
        if (DeleteendPosition != 0) {
            startPosition = [_tempData indexOfObject:parentNode]+1;
            endPosition = startPosition;
        }
        
        
        for (int i=0; i<FilerecordS.count; i++) {
            HCFilerecord *Filerecord = [FilerecordS objectAtIndex:i];
            NSUInteger startPosition = [_tempData indexOfObject:parentNode];
            [_FilerecordS insertObject:Filerecord atIndex:(startPosition + 1 + i)];
        }
        for (int i=0; i<NodeS.count; i++) {
            Node *NewNode = [NodeS objectAtIndex:i];
            NSUInteger startPosition = [_tempData indexOfObject:parentNode];
            [_data insertObject:NewNode atIndex:(startPosition+ 1 + i)];
        }
        
        
        for (int i=0; i<_data.count; i++) {
            Node *node = [_data objectAtIndex:i];
            if (node.parentId == parentNode.nodeId) {
                node.expand = !node.expand;
                if (node.expand) {
                    //插入节点
                    [_tempData insertObject:node atIndex:endPosition];
                    expand = YES;
                    endPosition++;
                }else{
                    expand = NO;
                    endPosition = [self removeAllNodesAtParentNode:parentNode];
                    break;
                }
            }
        }
        
        //获得需要修正的indexPath
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (NSUInteger i=startPosition; i<endPosition; i++) {
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:tempIndexPath];
        }
        
        //插入或者删除相关节点
        if (expand) {
            [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"请求失败%@",error);
    }];
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        if (node.depth > parentNode.depth) {
            endPosition++;
        }
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition)];
        [_data removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition)];
        [_FilerecordS removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition)];
    }
    return endPosition;
}

@end
