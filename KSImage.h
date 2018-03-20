//
//  KSImage.h
//  LastSupper
//
//  Created by 清水 一征 on 13/02/21.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSImage : NSObject

- (UIImage *)cropImageView:(UIImage *)image;
//- (UIImage *)selectedCropImageView:(UIImage *)image size:(int)size;
- (BOOL)isThumbSize:(UIImage *)image;
- (UIImage *)getThumbImage:(UIImage *)image;

@end
