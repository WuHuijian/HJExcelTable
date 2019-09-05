//
//  HJExcelTable.h
//  Trader
//
//  Created by WHJ on 2019/8/21.
//

#import <UIKit/UIKit.h>
#import "HJExcelCell.h"
#import "HJExcelConst.h"
/**
 * 说明 该控件section 0(即第一行) 为标题栏
 *
 */

typedef NS_ENUM(NSUInteger, HJExcelBorderMask) {
    HJExcelBorder_none          = 0,
    HJExcelBorder_outside       = 1 << 0,
    HJExcelBorder_inner_row     = 1 << 1,
    HJExcelBorder_inner_column  = 1 << 2,
    HJExcelBorder_inner = (HJExcelBorder_inner_row | HJExcelBorder_inner_column),
    HJExcelBorder_all = (HJExcelBorder_outside | HJExcelBorder_inner)
};


@class HJExcelCellConfig,HJExcelTable;

NS_ASSUME_NONNULL_BEGIN
@protocol HJExcelTableDelegate <NSObject>

@required
// cell所占宽度比
- (NSArray<NSNumber *> *)ratioOfCellWidth;

// 说明：这里不加indexPath 假设所有cell高度都是一致的
- (CGFloat)heightForCell;

// 第一行的标题
- (NSArray<NSString *> *)titlesForExcel;

// 所有数据项
- (NSArray *)datasForExcel;

@optional

// 标题行样式设置
- (HJExcelCellConfig *)excel:(HJExcelTable *)excel configCellForTitleAtIndexPath:(NSIndexPath *)indexPath;
// 数据行样式设置
- (HJExcelCellConfig *)excel:(HJExcelTable *)excel configCellForDataAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface HJExcelTable : UIView

@property (nonatomic, weak) id<HJExcelTableDelegate> delegate;

@property (nonatomic, assign) HJExcelBorderMask borderMask;

@property (nonatomic, strong) UIColor * borderColor;

@property (nonatomic, assign) BOOL borderInTitle;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
