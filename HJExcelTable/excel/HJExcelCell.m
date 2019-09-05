//
//  HJExcelCell.m
//  Trader
//
//  Created by WHJ on 2019/8/21.
//

#import "HJExcelCell.h"
#import "HJExcelConst.h"
#import "Masonry.h"


@implementation HJExcelCellConfig

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = DefaultTextColor;
    }
    return _textColor;
}

- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = DefaultBackgroundColor;
    }
    return _backgroundColor;
}

- (UIFont *)font
{
    if (!_font) {
        _font = DefaultFont;
    }
    return _font;
}

@end


@interface HJExcelCell ()

@property (nonatomic, strong) UILabel * textLabel;

@end


@implementation HJExcelCell

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
    [self.contentView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Pravite Method

#pragma mark - Public Method

#pragma mark - Event response

#pragma mark - Delegate methods

#pragma mark - Getters/Lazy
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

#pragma mark - Setters
- (void)setCellConfig:(HJExcelCellConfig *)cellConfig
{
    _cellConfig = cellConfig;
    self.textLabel.font = cellConfig.font;
    self.textLabel.textColor = cellConfig.textColor;
    
    self.backgroundColor = cellConfig.backgroundColor;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.textLabel.text = content;
}
@end
