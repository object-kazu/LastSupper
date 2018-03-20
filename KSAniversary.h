//
//  KSAniversasy.h
//  LastSupper
//
//  Created by 清水 一征 on 13/05/02.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDietController.h"
#import "def.h"

@interface KSAniversary : NSObject

- (NSDate *)appendDay:(NSDate *)baseDate DaysPlus:(NSInteger)days;
- (NSDate *)indicateDate:(NSDate *)baseDate TimesPlus:(NSInteger)times;
- (NSString *)indicateDiet:(NSInteger)times;
- (NSArray *)daysAndDiet:(NSInteger)times;

//attribute string
- (BOOL)isTodayOverAniversary:(NSDate *)aniversary;

- (GENERATION_Tag)gtagManager:(GENERATION_Tag)tag plus:(BOOL)plus;
- (NSInteger)generationTagConvertNSinteger:(GENERATION_Tag)generation;
- (GENERATION_Tag)dateConvertGeneration:(NSInteger)remainTimesAll;

@end
