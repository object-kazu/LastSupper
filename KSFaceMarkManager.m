//
//  KSFaceMarkManager.m
//  LastSupper
//
//  Created by 清水 一征 on 13/03/05.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSFaceMarkManager.h"

@interface KSFaceMarkManager ()

@end



@implementation KSFaceMarkManager

- (id)init {
    if ( self = [super init] ) {
        
        int    one_char = 1;
        
        if ( ITEMS.length != 3 ) {
            LOG_ERROR_METHOD;
        }
        _normal_state = [ITEMS substringWithRange:NSMakeRange(ITEMS.length - 3, one_char)];
        _good_state   = [ITEMS substringWithRange:NSMakeRange(ITEMS.length - 2, one_char)];
        _bad_state    = [ITEMS substringWithRange:NSMakeRange(ITEMS.length - 1, one_char)];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark ---------- item & string ----------
- (NSInteger)stringConvertItem:(NSString *)str {
    
    if ( str == NULL ) str = _normal_state;
    
    NSInteger    itemValue;
    if ( [str isEqualToString:_normal_state] ) {
        itemValue = normal_ITEM;
    } else if ( [str isEqualToString:_good_state] ) {
        itemValue = good_ITEM;
    } else if ( [str isEqualToString:_bad_state] ) {
        itemValue = bad_ITEM;
    } else {
        LOG_ERROR_METHOD;
        itemValue = ILLEGULAR_NUMBER;
    }
    
    return itemValue;
}

- (NSString *)itemConvertString:(NSInteger)item {
    
    item = [self ItemRegulate:item];
    NSString    *str = [self itemConvertCharactor:item];
    
    KSCalc      *calc = [[KSCalc alloc]init];
    NSString    *temp = [calc stringConvertImgFileName:str];
    
    calc = nil;
    
    return temp;
}

- (NSString *)itemConvertCharactor:(NSInteger)item {
    item = [self ItemRegulate:item];
    
    return [ITEMS substringWithRange:NSMakeRange(item, 1)];
}

- (NSInteger)ItemRegulate:(NSInteger)state {
    state = state % ITEMS.length;
    if ( state == 0 ) {
        state = 0;
    }
    
    return state;
}

- (UIImage *)imageSelect:(NSInteger)state {
    
    NSString    *selection = [self itemConvertString:state];
    
    return [UIImage imageNamed:selection];
    
}

@end
