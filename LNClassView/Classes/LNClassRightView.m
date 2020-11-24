//
//  LNClassRightView.m
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import "LNClassRightView.h"
#import "JXCategoryView.h"
#import "LNClassModel.h"
#import "LNClassUIModel.h"
#import <SDWebImage/SDWebImage.h>

@interface LNVerticalSectionCategoryHeaderView : UICollectionReusableView

@end

@implementation LNVerticalSectionCategoryHeaderView

@end


@interface LNClassBannerHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, copy)void(^handlerBannerOnTapBlock)(void);

@end


@implementation LNClassBannerHeaderView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imgView = [[UIImageView alloc]init];
        self.imgView.userInteractionEnabled = YES;
        [self addSubview:self.imgView];
        CGFloat margin = 16;
        self.imgView.frame = CGRectMake(margin, margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
     
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTaped)];
        [self.imgView addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)imgViewTaped{
    if (self.handlerBannerOnTapBlock) {
        self.handlerBannerOnTapBlock();
        
    }
}
@end


@interface LNVerticalListCollectionView : UICollectionView

@property (nonatomic, copy) void (^layoutSubviewsCallback)(void);

@end
@implementation LNVerticalListCollectionView


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.layoutSubviewsCallback) {
        self.layoutSubviewsCallback();
    }

}


@end

@interface  LNClassRightView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JXCategoryViewDelegate>


@property (nonatomic, strong) LNVerticalListCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <NSString *> *headerTitles;
@property (nonatomic, strong) JXCategoryTitleView *pinCategoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) LNVerticalSectionCategoryHeaderView *sectionCategoryHeaderView;
@property (nonatomic, strong) NSArray <UICollectionViewLayoutAttributes *> *sectionHeaderAttributes;

@property (nonatomic, assign) BOOL bannerFlag;//是否有bannner数据
@property (nonatomic, assign) CGFloat   headedImageHeight;
@property (nonatomic, strong) LNClassUIModel *viewModel;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, strong) Class itemClass;
@property (nonatomic, strong) Class headerClass;


@end

static const NSUInteger VerticalListPinSectionIndex = 1;    //悬浮固定section的index


@implementation LNClassRightView


#pragma mark - getter
- (LNVerticalListCollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[LNVerticalListCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        __weak typeof(self)weakSelf = self;
        _collectionView.layoutSubviewsCallback = ^{
            
            [weakSelf updateSectionHeaderAttributes];
        };
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LNClassBannerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerImggView"];
        [_collectionView registerClass:[LNVerticalSectionCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"categoryHeader"];
    }
    return _collectionView;
}
- (JXCategoryTitleView *)pinCategoryView {
    
    if (!_pinCategoryView) {
        _pinCategoryView = [[JXCategoryTitleView alloc] init];
        _pinCategoryView.titleSelectedColor = self.viewModel.selectedTitleColor;
        _pinCategoryView.titleColor = self.viewModel.titleColor;
        _pinCategoryView.titleFont = self.viewModel.titleFont;
        _pinCategoryView.titleSelectedFont = self.viewModel.titleSelectedFont;
        _pinCategoryView.backgroundColor = [UIColor whiteColor];
        _pinCategoryView.frame = CGRectMake(0, 0,self.frame.size.width, self.viewModel.titleViewSize.height);
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        self.pinCategoryView.indicators = @[lineView];
        self.pinCategoryView.delegate = self;
        self.lineView = lineView;
    }
    return _pinCategoryView;
}

#pragma mark - initial


+ (instancetype)rightViewWifthFrame:(CGRect)frame
                          itemClass:(Class)itemClass
                        headerClass:(Class)headerClass {
    
    LNClassRightView *view = [[LNClassRightView alloc]initWithFrame:frame itemClass:itemClass headerClass:headerClass];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame
                    itemClass:(Class)itemClass
                  headerClass:(Class)headerClass{
    if (self =  [super initWithFrame:frame]) {
        
        [self setUpDefaultUIModel];
        [self setupSubView];
        
        self.itemClass = itemClass;
        self.headerClass = headerClass;
        [self.collectionView registerClass:itemClass forCellWithReuseIdentifier:NSStringFromClass(itemClass)];
        [self.collectionView registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(headerClass)];
    }
    return self;
}

#pragma mark - public
- (void)setupheadImg:(NSString *)headImg {
    
    self.bannerFlag = headImg.length? YES :NO;
    self.headImg = headImg;
    __weak LNClassRightView *weakView = self;
    __block CGSize imageSize = CGSizeZero;
    void (^refreshViewBlock)(void) = ^(){
        
        if (imageSize.width != 0) {
            weakView.headedImageHeight =   (weakView.frame.size.width - 32)/imageSize.width*imageSize.height + 32; //+ 32间隙
        }
        [self.collectionView setContentOffset:CGPointZero animated:NO];
        self.sectionHeaderAttributes = nil;
        [self handlerData];
       
    };

    if (headImg.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            imageSize = [LNClassRightView getImageSizeWithURL:headImg];
            dispatch_async(dispatch_get_main_queue(), refreshViewBlock);
        });
    }else{
        self.headedImageHeight = 0.01;
        refreshViewBlock();
    }
  
}
- (void)setUIModel:(LNClassUIModel *)UIModel {
    
    [self.viewModel updateConfigModel:UIModel];
    
    self.viewModel = _viewModel;
}

#pragma mark - logic
/**
 获取网络图片高度
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
    
}

- (void)setUpDefaultUIModel {
    
    _viewModel = [[LNClassUIModel alloc]init];
    _viewModel.rightCellSize = CGSizeMake(77, 98);
    _viewModel.sectionTitleSize = CGSizeMake(self.frame.size.width, 35);
    _viewModel.minimumInteritemSpacing = 12;
    _viewModel.minimumLineSpacing = 12;
    _viewModel.insetForSection = UIEdgeInsetsMake(8, 16, 8, 16);
    _viewModel.titleViewSize = CGSizeMake(self.frame.size.width, 50);
    _viewModel.titleFont = [UIFont systemFontOfSize:12];
    _viewModel.titleSelectedFont = [UIFont boldSystemFontOfSize:12];
    _viewModel.selectedTitleColor =  UIColor.cyanColor;
    _viewModel.titleColor =  UIColor.grayColor;
    _viewModel.lineVerticalMargin = 8;
    _viewModel.lineIndicatorSize = CGSizeMake(12, 2);
    _viewModel.ineindicatorColor = UIColor.cyanColor;
    
    self.viewModel = _viewModel;
}

- (void)handlerData{
    [self.headerTitles removeAllObjects];
    [self.datas enumerateObjectsUsingBlock:^(LNClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.headerTitles addObject:obj.title];
    }];
    self.pinCategoryView.titles = self.headerTitles.copy;
    
    [self.pinCategoryView selectItemAtIndex:0];
    [self.collectionView reloadData];
    [self.pinCategoryView reloadData];
    [self scrollViewDidScroll:self.collectionView];
    
}


#pragma mark - subviews
- (void)setupSubView {
       
    [self addSubview:self.collectionView];
    
}

- (void)updateSectionHeaderAttributes {
    
    //判断obj.children是否有值
   __block   BOOL ret = NO;
    [self.datas enumerateObjectsUsingBlock:^(LNClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (!obj.children.count) {
            ret = YES;
        }
    }];
    if (ret) {
        if (self.sectionHeaderAttributes == nil && self.headerTitles.count) {
            
            //获取到所有的sectionHeaderAtrributes，用于后续的点击，滚动到指定contentOffset.y使用
            NSMutableArray *attributes = [NSMutableArray array];
            UICollectionViewLayoutAttributes *lastHeaderAttri = nil;
            
            NSUInteger count = self.headerTitles.count + 2;
            
            for (int i = 0; i < count; i++) {
                UICollectionViewLayoutAttributes *attri = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                if (attri) {
                    [attributes addObject:attri];
                }
                if (i == count - 1) {
                    lastHeaderAttri = attri;
                }
            }
            if (attributes.count == 0) {
                return;
            }
            self.sectionHeaderAttributes = attributes;
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - setter
- (void)setViewModel:(LNClassUIModel *)viewModel {
    
    _viewModel = viewModel;
    
    self.pinCategoryView.frame = CGRectMake(0, 0,self.frame.size.width, viewModel.titleViewSize.height);
    self.pinCategoryView.titleSelectedColor = viewModel.selectedTitleColor;
    self.pinCategoryView.titleColor = viewModel.titleColor;
    self.pinCategoryView.titleFont = viewModel.titleFont;
    self.pinCategoryView.titleSelectedFont = viewModel.titleSelectedFont;
    
    self.lineView.verticalMargin = viewModel.lineVerticalMargin;
    self.lineView.indicatorWidth = viewModel.lineIndicatorSize.width;
    self.lineView.indicatorHeight = viewModel.lineIndicatorSize.height;
    self.lineView.indicatorCornerRadius = viewModel.lineindicatorCornerRadius;
    self.lineView.indicatorColor = viewModel.ineindicatorColor;
    
}

- (void)setDatas:(NSArray<LNClassModel *> *)datas{
    
    if (!datas.count) return;
    
    _datas = datas;
    
    [self.collectionView setContentOffset:CGPointZero animated:NO];
    self.sectionHeaderAttributes = nil;
    [self handlerData];
    
}
#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.datas.count + 2;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return [_dataSource classView:collectionView identifer:self.itemClass rightCellForItemAtIndex:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 2]];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRightColumnAtIndex:)]) {
        [_delegate didSelectRightColumnAtIndex:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 2]];
    }

}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < 2) {
        return 0;
    }
    return self.datas[section - 2].children.count;
}
#pragma mark - SEL Mehthod

- (void)bannerOnClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBanner)]) {
        [self.delegate didClickBanner];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
            LNClassBannerHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerImggView" forIndexPath:indexPath];
            [headerView.imgView sd_setImageWithURL:[NSURL URLWithString:self.headImg] placeholderImage:[UIImage imageNamed:@"home_demo_cell_scroll"]];
            
            __weak LNClassRightView *weakView = self;
            [headerView setHandlerBannerOnTapBlock:^{
                
                [weakView bannerOnClick];
                
            }];
            return headerView;
        }else if (indexPath.section == VerticalListPinSectionIndex) {
            LNVerticalSectionCategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"categoryHeader" forIndexPath:indexPath];
            self.sectionCategoryHeaderView = headerView;
            if (self.pinCategoryView.superview == nil) {
                //首次使用VerticalSectionCategoryHeaderView的时候，把pinCategoryView添加到它上面。
                [headerView addSubview:self.pinCategoryView];
            }
            return headerView;
        }else {
            
            return [_dataSource classView:collectionView identifer:self.headerClass  rightReusableViewForItemAtIndex:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 2]];
        }
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"other" forIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UICollectionViewLayoutAttributes *attri = [self.sectionHeaderAttributes objectAtIndex:VerticalListPinSectionIndex];
    if (attri && scrollView.contentOffset.y > attri.frame.origin.y) {
        //当滚动的contentOffset.y大于了指定sectionHeader的y值，且还没有被添加到self.view上的时候，就需要切换superView
        if (self.pinCategoryView.superview != self) {
            [self addSubview:self.pinCategoryView];
        }
    }else if (self.pinCategoryView.superview != self.sectionCategoryHeaderView) {
        //当滚动的contentOffset.y小于了指定sectionHeader的y值，且还没有被添加到sectionCategoryHeaderView上的时候，就需要切换superView
        [self.sectionCategoryHeaderView addSubview:self.pinCategoryView];
    }
    
    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
        return;
    }
    //用户滚动的才处理
    //获取categoryView下面一点的所有布局信息，用于知道，当前最上方是显示的哪个section
    CGRect topRect = CGRectMake(0, scrollView.contentOffset.y + self.viewModel.titleViewSize.height + 1, self.frame.size.width, 1);
    UICollectionViewLayoutAttributes *topAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:topRect].firstObject;
    NSUInteger topSection = topAttributes.indexPath.section;
    NSLog(@"topSection:%ld-----",topSection);

       if (topSection != 0) {
           topSection -= 1;
       }

    if (topAttributes != nil && topSection >= VerticalListPinSectionIndex) {
        if (self.pinCategoryView.selectedIndex != topSection - VerticalListPinSectionIndex) {
            //不相同才切换
            [self.pinCategoryView selectItemAtIndex:topSection - VerticalListPinSectionIndex];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(collectionView.frame.size.width,self.headedImageHeight);
    }else if (section == VerticalListPinSectionIndex) {
        //categoryView所在的headerView要高一些
        return CGSizeMake(collectionView.frame.size.width, self.viewModel.titleViewSize.height);
    }
    return CGSizeMake(collectionView.frame.size.width, self.viewModel.sectionTitleSize.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNClassModel *sectionModel = [self.datas objectAtIndex:indexPath.section - 2];
     if (sectionModel.children.count) {
         
         return self.viewModel.rightCellSize;
     }
    return CGSizeMake(collectionView.frame.size.width, 215);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.viewModel.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    LNClassModel *sectionModel = [self.datas objectAtIndex:section - 2];
        if (sectionModel.children.count) {
            return self.viewModel.minimumInteritemSpacing;
        }
    return 0.01;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    LNClassModel *sectionModel = [self.datas objectAtIndex:section - 2];
         if (sectionModel.children.count) {
             return self.viewModel.insetForSection;
         }
    return UIEdgeInsetsZero;
}


#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    //这里关心点击选中的回调！！！
    
    index = index + 2;
    UICollectionViewLayoutAttributes *targetAttri = [self.sectionHeaderAttributes objectAtIndex: index];
    
    [self.collectionView setContentOffset:CGPointMake(0, targetAttri.frame.origin.y - self.viewModel.titleViewSize.height) animated:YES];
    
}
#pragma mark - Getter

- (NSMutableArray<NSString *> *)headerTitles{
    if (!_headerTitles) {
        _headerTitles = [NSMutableArray array];
    }
    return _headerTitles;
}

@end
