//
//  HJExcelTable.m
//  Trader
//
//  Created by WHJ on 2019/8/21.
//

#import "HJExcelTable.h"
#import "Masonry.h"

@interface HJExcelTable ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<NSNumber *> *cellWidthRatios;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, strong) NSArray *allDatas;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSMutableArray * separateLines;

@end

@implementation HJExcelTable

#pragma mark - Life Circle
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - About UI
- (void)setupUI
{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self reloadData];
}

- (void)reloadData
{
    if ([self.delegate respondsToSelector:@selector(ratioOfCellWidth)]) {
        self.cellWidthRatios = [self.delegate ratioOfCellWidth];
    }
    
    if ([self.delegate respondsToSelector:@selector(heightForCell)]) {
        self.cellH = [self.delegate heightForCell];
    }
    
    if ([self.delegate respondsToSelector:@selector(titlesForExcel)]) {
        self.titles = [self.delegate titlesForExcel];
    }
    
    if ([self.delegate respondsToSelector:@selector(datasForExcel)]) {
        self.allDatas = [self.delegate datasForExcel];
    }
    
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupBorder];
    });
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.separateLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView bringSubviewToFront:obj];
    }];
}

- (void)setupBorder
{
    [self.separateLines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.separateLines removeAllObjects];
    
    
    BOOL showOutside = (self.borderMask & HJExcelBorder_outside);
    BOOL showInnerColumn = (self.borderMask & HJExcelBorder_inner_column);
    BOOL showInnerRow = (self.borderMask & HJExcelBorder_inner_row);
    
    
    if (showOutside) {
        
        UIView * lineTop = [self createLine];
        UIView * lineBottom = [self createLine];
        UIView * lineLeft = [self createLine];
        UIView * lineRight = [self createLine];
        
        lineTop.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
        lineBottom.frame = CGRectMake(0, (self.allDatas.count+1) * self.cellH-1, CGRectGetWidth(self.frame), 1);
        lineLeft.frame = CGRectMake(0, 0, 1, (self.allDatas.count+1) * self.cellH);
        lineRight.frame = CGRectMake(CGRectGetWidth(self.frame)-1, 0, 1, (self.allDatas.count+1) * self.cellH);
        
        [self.separateLines addObject:lineTop];
        [self.separateLines addObject:lineBottom];
        [self.separateLines addObject:lineLeft];
        [self.separateLines addObject:lineRight];
    }
    
    if (showInnerRow) {
        for(NSInteger row = 1; row <= (self.allDatas.count); row++){
            UIView * line = [self createLine];
            line.frame = CGRectMake(0, self.cellH*(row), CGRectGetWidth(self.frame), 1);
            [self.separateLines addObject:line];
        }
    }
    
    if (showInnerColumn) {
        CGFloat originY = self.borderInTitle ? 0 : self.cellH;
        CGFloat height = self.borderInTitle ? (self.allDatas.count+1)*self.cellH : self.allDatas.count * self.cellH;
        for(NSInteger column = 1; column < self.titles.count; column++){
            UIView * line = [self createLine];
            line.frame = CGRectMake([self calcWidthToColumn:column], originY, 1, height);
            [self.separateLines addObject:line];
        }
    }
}

- (UIView *)createLine
{
    UIView * line = [UIView new];
    line.backgroundColor = self.borderColor;
    [self.collectionView addSubview:line];
    return line;
}

#pragma mark - Pravite Method
- (CGSize)itemSizeWithIndexPath:(NSIndexPath *)indexPath
{
    __block CGFloat allRatio = 0;
    [self.cellWidthRatios enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        allRatio += [obj floatValue];
    }];
    
    CGFloat width = CGRectGetWidth(self.frame) * ([self.cellWidthRatios[indexPath.item] floatValue]/allRatio);
    CGFloat height = self.cellH;
    return CGSizeMake(width, height);
}


- (CGFloat)calcWidthToColumn:(NSInteger)column
{
    __block CGFloat allRatio = 0;
    __block CGFloat toColumnRatio = 0;
    [self.cellWidthRatios enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        allRatio += [obj floatValue];
        if (idx<column) {
            toColumnRatio += [obj floatValue];
        }
    }];
    CGFloat width = CGRectGetWidth(self.frame) * (toColumnRatio/allRatio);
    return width;
}
#pragma mark - Public Method

#pragma mark - Event response

#pragma mark - Delegate methods
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    return self.titles ? self.titles.count : 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HJExcelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HJExcelCell" forIndexPath:indexPath];
    
    HJExcelCellConfig * config = nil;
    NSString * content = nil;
    
    if (indexPath.section == 0) {// 标题组
        if ([self.delegate respondsToSelector:@selector(excel:configCellForTitleAtIndexPath:)]) {
            config = [self.delegate excel:self configCellForTitleAtIndexPath:indexPath];
        }
        content = self.titles[indexPath.item];
    }else{
        if ([self.delegate respondsToSelector:@selector(excel:configCellForDataAtIndexPath:)]) {
            config = [self.delegate excel:self configCellForDataAtIndexPath:indexPath];
        }
        content = self.allDatas[indexPath.section-1][indexPath.item];
    }
    cell.cellConfig = config;
    cell.content = content;
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;{
    
    if (!self.titles) {
        return 0;
    }
    
    if (self.allDatas) {
        return self.allDatas.count + 1;
    }
    
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    return [self itemSizeWithIndexPath:indexPath];
}

#pragma mark - Getters/Lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeZero;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HJExcelCell class] forCellWithReuseIdentifier:@"HJExcelCell"];
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingNone;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.delaysContentTouches = YES;
        _collectionView.clipsToBounds = YES;
    }
    return _collectionView;
}


- (NSMutableArray *)separateLines
{
    if (!_separateLines) {
        _separateLines = [[NSMutableArray alloc] init];
    }
    return _separateLines;
}

- (UIColor *)borderColor
{
    if (!_borderColor) {
        _borderColor = DefaultBorderColor;
    }
    return _borderColor;
}
#pragma mark - Setters
- (void)setDelegate:(id<HJExcelTableDelegate>)delegate
{
    _delegate = delegate;
    
    [self reloadData];
}

- (void)setBorderMask:(HJExcelBorderMask)borderMask
{
    _borderMask = borderMask;
    
    [self reloadData];
}
@end
