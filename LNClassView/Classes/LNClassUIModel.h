//
//  LNClassUIModel.h
//  LiNingApp
//
//  Created by carrot on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNClassUIModel : NSObject

#pragma mark - 右边分类
/** cellSize*/
@property (nonatomic, assign) CGSize rightCellSize;
/** 分组透视图 size*/
@property (nonatomic, assign) CGSize sectionTitleSize;
/** 同一列中间隔的cell最小间距*/
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/** 最小行间距*/
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/** setion的缩进*/
@property (nonatomic, assign) UIEdgeInsets insetForSection;

#pragma mark - titleView

/** 右边分类指定标题size*/
@property (nonatomic, assign) CGSize titleViewSize;
/** 置顶标题常规字体*/
@property (nonatomic, strong) UIFont *titleFont;
/** 置顶标题选中字体*/
@property (nonatomic, strong) UIFont *titleSelectedFont;
/** 置顶标题选中字颜色*/
@property (nonatomic, strong) UIColor *selectedTitleColor;
/** 置顶标题选中字默认颜色*/
@property (nonatomic, strong) UIColor *titleColor;

#pragma mark - titleView下划线

/** 距离标题竖向间距*/
@property (nonatomic, assign) CGFloat lineVerticalMargin;
/** 下划线大小*/
@property (nonatomic, assign) CGSize lineIndicatorSize;
/** 下划线颜色*/
@property (nonatomic, strong) UIColor *ineindicatorColor;
/** 下划线圆角*/
@property (nonatomic, assign) CGFloat lineindicatorCornerRadius;

- (void)updateConfigModel:(LNClassUIModel *)model;
@end

NS_ASSUME_NONNULL_END
