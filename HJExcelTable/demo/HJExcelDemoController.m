//
//  HJExcelDemoController.m
//  HJExcelTable
//
//  Created by WHJ on 2019/9/5.
//  Copyright © 2019 WHJ. All rights reserved.
//

#import "HJExcelDemoController.h"
#import "Masonry.h"
#import "HJExcelTable.h"

@interface HJExcelDemoController ()<HJExcelTableDelegate>

@property (nonatomic, strong) HJExcelTable *excel;
// 次数
@property (nonatomic, assign) NSInteger times;

@end

@implementation HJExcelDemoController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    [self startTimer];
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - About UI
- (void)setupUI
{
    self.excel = [[HJExcelTable alloc] initWithFrame:self.view.bounds];
    self.excel.layer.cornerRadius = 4.f;
    self.excel.layer.masksToBounds = YES;
    self.excel.borderMask = HJExcelBorder_outside | HJExcelBorder_inner_row;
    self.excel.delegate = self;
    [self.view addSubview:self.excel];
    
    [self.excel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 15, 20, 15));
    }];
}
#pragma mark - About Data

#pragma mark - Pravite Method
- (void)startTimer
{
    NSArray * borderMasks = @[
                              @(HJExcelBorder_none),
                              @(HJExcelBorder_outside),
                              @(HJExcelBorder_outside | HJExcelBorder_inner_row),
                              @(HJExcelBorder_inner),
                              @(HJExcelBorder_all)
                              ];
    __weak typeof(self) weak_self = self;
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        weak_self.excel.borderMask = [borderMasks[weak_self.times%borderMasks.count] integerValue];
        [weak_self.excel reloadData];
        weak_self.times ++;
    }];
}
#pragma mark - Public Method

#pragma mark - Event response

#pragma mark - Delegate methods

#pragma mark - HRExcelTableDelegate
    
// cell所占宽度比
- (NSArray<NSNumber *> *)ratioOfCellWidth
{
    return @[@1,@1,@1,@(1.8),@1];
}

// 说明：这里不加indexPath 假设所有cell高度都是一致的
- (CGFloat)heightForCell
{
    return 40.f;
}

// 第一行的标题
- (NSArray<NSString *> *)titlesForExcel
{
    return @[@"姓名",@"工号",@"部门",@"登录号码",@"入职日期"];
}

// 所有数据项
- (NSArray *)datasForExcel
{
    return @[
             @[@"张三",@"QY001",@"产品部",@"13811233445",@"7-1"],
             @[@"李四",@"QY002",@"技术部",@"13811233445",@"7-2"],
             @[@"王五",@"QY003",@"技术部",@"13811233445",@"7-2"],
             @[@"张三",@"QY001",@"产品部",@"13811233445",@"7-1"],
             @[@"李四",@"QY002",@"技术部",@"13811233445",@"7-2"],
             @[@"王五",@"QY003",@"技术部",@"13811233445",@"7-2"],
             ];
}
    
// 标题行样式设置
- (HJExcelCellConfig *)excel:(HJExcelTable *)excel configCellForTitleAtIndexPath:(NSIndexPath *)indexPath
{
    HJExcelCellConfig * cellConfig = [[HJExcelCellConfig alloc] init];
    cellConfig.textColor = DefaultTitleTextColor;
    cellConfig.backgroundColor = DefaultTitleBackgroundColor;
    return cellConfig;
}
// 数据行样式设置
- (HJExcelCellConfig *)excel:(HJExcelTable *)excel configCellForDataAtIndexPath:(NSIndexPath *)indexPath;
{
    
    HJExcelCellConfig * cellConfig = nil;
    if((self.times % 4) == 0){// 正常显示
         cellConfig = [[HJExcelCellConfig alloc] init];
    }else if((self.times % 4) == 1){// 行颜色交替
        cellConfig = [[HJExcelCellConfig alloc] init];
        cellConfig.backgroundColor = (indexPath.section%2 != 0)?[UIColor whiteColor]:[UIColor lightGrayColor];
    }else if((self.times % 4) == 2){// 列颜色交替
        cellConfig = [[HJExcelCellConfig alloc] init];
        cellConfig.backgroundColor = (indexPath.item%2 != 0)?[UIColor whiteColor]:[UIColor lightGrayColor];
    }else if((self.times % 4) == 3){// cell随机色
        cellConfig = [[HJExcelCellConfig alloc] init];
        NSInteger red = arc4random()*1000 % 255;
        NSInteger green = arc4random()*1000 % 255;
        NSInteger blue = arc4random()*1000 % 255;
        cellConfig.backgroundColor = [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
    }
    return cellConfig;
}
    
#pragma mark - Getters/Lazy

#pragma mark - Setters

@end
