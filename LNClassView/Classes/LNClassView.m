//
//  LNClassView.m
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import "LNClassView.h"
#import "LNClassLeftView.h"
#import "LNClassRightView.h"
#import "LNClassModel.h"

@interface LNClassView ()

@property (nonatomic, strong) LNClassLeftView *leftView;

@property (nonatomic, strong) LNClassRightView *rightView;

@property (nonatomic, assign) CGFloat leftColumnWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat classMargin;
@property (nonatomic, strong) Class leftCellClass;
@property (nonatomic, strong) Class rightCellClass;
@property (nonatomic, strong) Class rightHeaderCellClass;

@end

@implementation LNClassView

#pragma mark – Setter && Getter Methods
- (LNClassLeftView *)leftView{
    if (!_leftView) {
        _leftView = [LNClassLeftView leftViewWidthFrame:CGRectMake(0, 0, self.leftColumnWidth, self.frame.size.height) cellHeight:self.cellHeight cellClass:self.leftCellClass];
        
    }
    return _leftView;
    
}
- (LNClassRightView *)rightView{
    if (!_rightView) {
        CGFloat x = self.leftColumnWidth + self.classMargin;
        _rightView = [LNClassRightView rightViewWifthFrame:CGRectMake(self.leftColumnWidth + self.classMargin, 0, self.frame.size.width - x - self.classMargin, self.frame.size.height) itemClass:self.rightCellClass headerClass:self.rightHeaderCellClass];
    }
    return _rightView;
}

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
                     leftCellClass:(nonnull Class)leftCellClass
                    rightCellClass:(nonnull Class)rightCellClass
                  rightHeaderClass:(nonnull Class)rightHeaderClass{
    
    LNClassView *view = [[LNClassView alloc]initWithFrame:frame leftColumnWidth:leftColumnWidth cellHeight:leftCellHeight classMargin:classMargin leftCellClass:leftCellClass rightCellClass:rightCellClass rightHeaderClass:rightHeaderClass];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
              leftColumnWidth:(CGFloat)leftColumnWidth
                   cellHeight:(CGFloat)cellHeight
                  classMargin:(CGFloat)margin
                leftCellClass:(nonnull Class)leftCellClass
               rightCellClass:(nonnull Class)rightCellClass
             rightHeaderClass:(nonnull Class)rightHeaderClass
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftColumnWidth = leftColumnWidth;
        self.cellHeight = cellHeight;
        self.classMargin = margin;
        self.leftCellClass = leftCellClass;
        self.rightCellClass = rightCellClass;
        self.rightHeaderCellClass = rightHeaderClass;

        [self setupSubView];
        
    }
    return self;
}

- (void)setupSubView{
    
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    
}

#pragma public
- (void)setHeadImg:(NSString *)headImg {
    
    [self.rightView setupheadImg:headImg];
}
- (void)reloadDataWithModel:(LNClassModel *)model {
    
    [self.leftView reloadData];
    self.rightView.datas = model.children;
}
#pragma mark - setter
- (void)setDataSurce:(id<LNClassViewDataSource>)dataSurce {
    
    self.leftView.dataSource = dataSurce;
    self.rightView.dataSource = dataSurce;
}
- (void)setDelegate:(id<LNClassViewDelegate>)delegate {
    
    self.leftView.delegate = delegate;
    self.rightView.delegate = delegate;
    
}
- (void)setConfigModel:(LNClassUIModel *)configModel {
    
    self.rightView.UIModel = configModel;
}
- (void)setDataArray:(NSArray<LNClassModel *> *)dataArray{
    
    _dataArray = dataArray;
    
    self.leftView.datas = dataArray;
    
    [dataArray enumerateObjectsUsingBlock:^(LNClassModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.select = YES;
            self.rightView.datas = obj.children;
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectLeftColumnAtIndex:)]) {
                [self.delegate didSelectLeftColumnAtIndex:idx];
            }
            *stop = YES;
        }
    }];
}



@end
