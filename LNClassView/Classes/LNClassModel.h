//
//  LNClassModel.h
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNClassModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, strong) NSMutableArray <LNClassModel *>*children;


@end

NS_ASSUME_NONNULL_END
