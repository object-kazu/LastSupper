//
//  KSColor.h
//  LastSupper
//
//  Created by 清水 一征 on 13/02/22.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSColor : NSObject

- (NSArray *)backgroundColors;
- (CGFloat)normalizeHue:(CGFloat)Hue;
- (NSArray *)gradient_colors_back;

@end
