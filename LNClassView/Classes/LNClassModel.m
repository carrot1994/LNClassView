//
//  LNClassModel.m
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import "LNClassModel.h"

@implementation LNClassModel

- (NSMutableArray<LNClassModel *> *)children {
    
    if (!_children) {
        _children = [NSMutableArray array];
    }
    return _children;
}

@end
