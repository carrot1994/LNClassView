//
//  LNClassLeftView.h
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import <UIKit/UIKit.h>
#import "LNClassView.h"

@class LNClassViewModel;
@class LNClassModel;


NS_ASSUME_NONNULL_BEGIN



@interface LNClassLeftView : UIView

+ (instancetype)leftViewWidthFrame:(CGRect)frame
                        cellHeight:(CGFloat)cellHeight
                         cellClass:(Class)cellClass;

@property (nonatomic, weak) id <LNClassViewDataSource> dataSource;
@property (nonatomic, weak) id <LNClassViewDelegate> delegate;

@property (nonatomic, strong) NSArray *datas;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
