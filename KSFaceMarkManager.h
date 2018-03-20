//
//  KSFaceMarkManager.h
//  LastSupper
//
//  Created by 清水 一征 on 13/03/05.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "def.h"
#import "KSCalc.h"
#import "KSEditViewController.h"

@interface KSFaceMarkManager : NSObject

@property (strong, nonatomic) NSString    *normal_state;
@property (strong, nonatomic) NSString    *good_state;
@property (strong, nonatomic) NSString    *bad_state;

- (NSInteger)stringConvertItem:(NSString *)str;
- (NSString *)itemConvertString:(NSInteger)item;
- (NSString *)itemConvertCharactor:(NSInteger)item;
- (UIImage *)imageSelect:(NSInteger)state;
- (NSInteger)ItemRegulate:(NSInteger)state;


@end
