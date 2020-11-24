//
//  LNClassLeftView.m
//  ZEHLiNingTestDemo
//
//  Created by carrot on 2020/11/17.
//

#import "LNClassLeftView.h"

@interface LNClassLeftView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Class cellClass;


@end
@implementation LNClassLeftView

+ (instancetype)leftViewWidthFrame:(CGRect)frame
                        cellHeight:(CGFloat)cellHeight
                         cellClass:(Class)cellClass {
    
    LNClassLeftView *view = [[LNClassLeftView alloc]initWithFrame:frame cellHeight:cellHeight cellClass:cellClass];
    
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame
                   cellHeight:(CGFloat)cellHeight
                    cellClass:(Class)cellClass{
    if (self = [super initWithFrame:frame]) {
        
        self.cellClass = cellClass;
        [self addSubview:self.tableView];
        self.tableView.rowHeight = cellHeight;
        [self.tableView registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
    return self;
    
}
#pragma mark - public
- (void)reloadData {
    
    [self.tableView reloadData];
}
#pragma mark – <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataSource respondsToSelector:@selector(classView:identifer:leftCellForItemAtIndex:)]) {
        return [_dataSource classView:tableView identifer:NSStringFromClass(self.cellClass) leftCellForItemAtIndex:indexPath.row];
    }
    return [[UITableViewCell alloc]init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    for (LNClassModel *model in self.datas) {
        model.select = NO;
    }
    LNClassModel *selectModel = [self.datas objectAtIndex:indexPath.row];
    selectModel.select = YES;
    [tableView reloadData];

    if ([self.delegate respondsToSelector:@selector(didSelectLeftColumnAtIndex:)]) {
         [_delegate didSelectLeftColumnAtIndex:indexPath.row];
    }

}
#pragma mark – Getter Method

- (UITableView *)tableView{
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.frame = self.bounds;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView = tableView;
    }
    
    return _tableView;
    
}
@end
