//
//  HJExcelCell.h
//  Trader
//
//  Created by WHJ on 2019/8/21.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HJExcelCellConfig : NSObject

@property (nonatomic, assign) UIFont * font;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * backgroundColor;

@end

@interface HJExcelCell : UICollectionViewCell

@property (nonatomic, strong) HJExcelCellConfig * cellConfig;

@property (nonatomic, strong) NSString * content;

@end

NS_ASSUME_NONNULL_END
