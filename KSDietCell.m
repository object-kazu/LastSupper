//
//  KSDietCell.m
//  LastSupper
//
//  Created by 清水 一征 on 12/10/31.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import "KSDietCell.h"
#import "KSCalc.h"
#import "def.h"
#import "KSColor.h"

@implementation KSDietCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( !self ) {
        return nil;
    }
    
    CGFloat fontSize = 16.0f;
    _yearLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
    _yearLabel.font            = [UIFont systemFontOfSize:fontSize];
    _yearLabel.textColor       = [UIColor grayColor];
    _yearLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_yearLabel];
    
    _monthAndDayLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
    _monthAndDayLabel.font            = [UIFont boldSystemFontOfSize:fontSize];
    _monthAndDayLabel.textColor       = [UIColor blackColor];
    _monthAndDayLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_monthAndDayLabel];
    
    UIImage    *image = [UIImage imageNamed:NORMAL_FACE];
    _morningImage = [[UIImageView alloc] initWithImage:image];
    
    [self.contentView addSubview:_morningImage];
    
    _lunchImage = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:_lunchImage];
    
    _dinnerImage = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:_dinnerImage];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -
#pragma mark ---------- layout ----------

- (void)layoutSubviews {
    CGRect    rect;
    
    // 親クラスのメソッドを呼び出す
    [super layoutSubviews];
    
    // year label
    CGFloat    base_x      = 5;
    CGFloat    base_y      = 5;
    CGFloat    label_width = 80;
    CGFloat    label_heigh = 20;
    CGSize     labelsize   = CGSizeMake(label_width, label_heigh);
    
    rect.origin.x    = base_x;
    rect.origin.y    = base_y;
    rect.size.width  = labelsize.width;
    rect.size.height = labelsize.height;
    
    _yearLabel.frame = rect;
    
    // month label
    rect.origin.x    = base_x;
    rect.origin.y    = self.frame.size.height * 0.5;
    rect.size.width  = labelsize.width;
    rect.size.height = labelsize.height;
    
    _monthAndDayLabel.frame = rect;
    
    // face mark
    CGFloat    facemark_width  = 40;
    CGFloat    facemark_height = 40;
    CGSize     imageSize       = CGSizeMake(facemark_width, facemark_height);
    CGFloat    cellHeight_half = self.contentView.frame.size.height * 0.5;
    CGFloat    marge           = 20;
    
    rect.origin.x       = base_x + labelsize.width + marge;
    rect.origin.y       = cellHeight_half - imageSize.height * 0.5;
    rect.size.width     = imageSize.width;
    rect.size.height    = imageSize.height;
    _morningImage.frame = rect;
    
    rect.origin.x     = base_x + labelsize.width + marge + imageSize.width + marge;
    _lunchImage.frame = rect;
    
    rect.origin.x      = base_x + labelsize.width + marge + imageSize.width + marge + imageSize.width + marge;
    _dinnerImage.frame = rect;
    
}

- (void)drawRect:(CGRect)rect {
    // CGContextを用意する
    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    // CGGradientを生成する
    // 生成するためにCGColorSpaceと色データの配列が必要になるので
    // 適当に用意する
    CGGradientRef      gradient;
    CGColorSpaceRef    colorSpace;
    size_t             num_locations = 2;
    CGFloat            locations[2]  = { 0.0, 1.0 };
    
    //start color RGB
    float              r = (float)255 / 255;
    float              g = (float)236 / 255;
    float              b = (float)202 / 255;
    
    CGFloat            components[12] = { r, g,   b,   0.5, //start color
        r,            g,   b,   1.0,
        0.5,          0.5, 0.5, 1.0 }; // end color
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient   = CGGradientCreateWithColorComponents(colorSpace, components,
                                                     locations, num_locations);
    
    // 生成したCGGradientを描画する
    // 始点と終点を指定してやると、その間に直線的なグラデーションが描画される。
    // （横幅は無限大）
    CGPoint    startPoint = CGPointMake(self.frame.size.width / 2, 0.0);
    CGPoint    endPoint   = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // GradientとColorSpaceを開放する
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
