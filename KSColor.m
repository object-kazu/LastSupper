//
//  KSColor.m
//  LastSupper
//
//  Created by 清水 一征 on 13/02/22.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSColor.h"
#import "def.h"
#import "KSCalc.h"

@implementation KSColor

#define Time_6_Hour 6

- (NSArray *)backgroundColors {
    
    KSCalc       *calc = [[KSCalc alloc]init];
    
    NSInteger    _hour_ = [calc separateDateComponets:[NSDate date]].hour;
    
    float        float_time_start = (_hour_ + Time_6_Hour) * TIME_1_24_HOUR; // 1/24
    CGFloat      startColorHue    = [self normalizeHue:(CGFloat)float_time_start];
    
    float        float_time_end = (_hour_ - Time_6_Hour) * TIME_1_24_HOUR;
    CGFloat      endColorHue    = [self normalizeHue:(CGFloat)float_time_end];
    
    NSNumber     *start = [NSNumber numberWithFloat:startColorHue];
    NSNumber     *end   = [NSNumber numberWithFloat:endColorHue];
    NSArray      *arr   = [NSArray arrayWithObjects:start, end, nil];
    
    calc = nil;
    
    return arr;
}

- (CGFloat)normalizeHue:(CGFloat)Hue {
    CGFloat    normalize_hue;
    
    if ( Hue > 1.0 ) {
        normalize_hue = Hue - 1;
    } else if ( Hue < 0 ) {
        normalize_hue = 1 + Hue;
    } else {
        normalize_hue = Hue;
    }
    
    return normalize_hue;
}

- (NSArray *)gradient_colors_back {
    
    NSArray    *array = [NSArray arrayWithObjects:
                         (id)[[UIColor whiteColor] CGColor],
                         (id)[RGBA(BASE_R, BASE_G, BASE_B, 0.6) CGColor],
                         (id)[RGBA(BASE_R, BASE_G, BASE_B, 0.8) CGColor],
                         (id)[RGBA(BASE_R, BASE_G, BASE_B, 1.0) CGColor],
                         (id)[RGBA(BASE_R, BASE_G, BASE_B, 0.8) CGColor],
                         (id)[RGBA(BASE_R, BASE_G, BASE_B, 0.6) CGColor],
                         (id)[[UIColor whiteColor] CGColor],
                         nil];
    
    return array;
    
}

@end
