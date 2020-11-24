//
//  LNClassView.h
//  LiNingApp
//
//  Created by carrot on 2020/11/20.
//

#import <UIKit/UIKit.h>
#import "LNClassUIModel.h"
#import "LNClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LNClassView;

@protocol LNClassViewDataSource <NSObject>

@optional
- (__kindof UICollectionViewCell *)classView:(UICollectionView *)classView
                                   identifer:(NSString *)identifer
                     rightCellForItemAtIndex:(NSIndexPath *)index;

- (__kindof UITableViewCell *)classView:(UITableView *)classView
                              identifer:(NSString *)identifer
                 leftCellForItemAtIndex:(NSInteger)index;


- (__kindof UICollectionReusableView *)classView:(UICollectionView *)classView
                                       identifer:(NSString *)identifer
                 rightReusableViewForItemAtIndex:(NSIndexPath *)index;

@end

@protocol LNClassViewDelegate <NSObject>

@optional

/** 点击左边分类 */
- (void)didSelectLeftColumnAtIndex:(NSInteger)index;

/** 点击右边分类item*/
- (void)didSelectRightColumnAtIndex:(NSIndexPath *)index;

/** 点击banner */
- (void)didClickBanner;

@end


@interface LNClassView : UIView

/** 设置右边分类的UI*/
@property (nonatomic, strong) LNClassUIModel *configModel;
@property (nonatomic, weak) id <LNClassViewDataSource> dataSurce;
@property (nonatomic, weak) id <LNClassViewDelegate> delegate;


///  类方法
/// @param frame classView布局
/// @param leftColumnWidth 左边分类宽度
/// @param leftCellHeight 左边分类cell高度
/// @param classMargin 一级二级分类间距
/// @param leftCellClass 左边分类cellClass
/// @param rightCellClass 右边分类cellClass
/// @param rightHeaderClass 右边分类headerClass
+ (instancetype)classViewWithFrame:(CGRect)frame
                   leftColumnWidth:(CGFloat)leftColumnWidth
                    leftCellHeight:(CGFloat)leftCellHeight
                       classMargin:(CGFloat)classMargin
                     leftCellClass:(Class)leftCellClass
                    rightCellClass:(Class)rightCellClass
                  rightHeaderClass:(Class)rightHeaderClass;


/**⚠️ 数据model一定要继承自LNClassModel */
@property (nonatomic, strong) NSArray <LNClassModel *>*dataArray;

/** 不设置顶部图片默认没有banner*/
@property (nonatomic) NSString *headImg;
         
/** 刷新右边分类数据*/
- (void)reloadDataWithModel:(LNClassModel *)model;

@end

NS_ASSUME_NONNULL_END
