//
//  LNClassRightView.h
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import <UIKit/UIKit.h>
#import "LNClassView.h"

@class LNClassModel;
@class LNClassUIModel;


NS_ASSUME_NONNULL_BEGIN


@interface LNClassRightView : UIView

- (void)setupheadImg:(NSString *)headImg;

@property (nonatomic, strong) NSArray <LNClassModel *> *datas;
@property (nonatomic, strong) LNClassUIModel *UIModel;
@property (nonatomic, weak) id <LNClassViewDataSource> dataSource;
@property (nonatomic, weak) id <LNClassViewDelegate> delegate;

+ (instancetype)rightViewWifthFrame:(CGRect)frame
                          itemClass:(Class)itemClass
                        headerClass:(Class)headerClass;


@end

NS_ASSUME_NONNULL_END
