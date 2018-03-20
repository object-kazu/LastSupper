//
//  KSCalc.m
//  LastSupper
//
//  Created by 清水 一征 on 12/11/04.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import "KSCalc.h"
#import "def.h"
#import <QuartzCore/QuartzCore.h>

#define PERCENT_100 100

@interface KSCalc ()

@end

@implementation KSCalc

- (id)init {
    if ( self = [super init] ) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark ---------- property ----------
#pragma mark -
#pragma mark ---------- Percent ----------
- (float)percentRemainAll {
    
    if ( [self totalTimes] == 0 ) return 100;
    
    float    percentRemain = ((float)[self remainTimesAll] / (float)[self totalTimes]) * 100;
    
    if ( percentRemain > PERCENT_100 ) percentRemain = PERCENT_100;
    
    return percentRemain;
}

- (float)percentDoneAll {
    if ( [self totalTimes] == 0 ) return 100;
    
    float    percentDone = (float)[self doneTimesAll] / [self totalTimes] * 100;
    
    if ( percentDone > PERCENT_100 ) percentDone = PERCENT_100;
    
    return percentDone;
}

- (float)percentRemainThisYear {
    if ( [self totalTimes] == 0 ) return 100;
    
    float    percentRemainThis = (float)[self remainTimesThisYear] / [self thisYearTimes] * 100;
    
    if ( percentRemainThis > PERCENT_100 ) percentRemainThis = PERCENT_100;
    
    return percentRemainThis;
}

- (float)percentDoneThisYear {
    if ( [self totalTimes] == 0 ) return 100;
    
    float    percentDoneThis = (float)[self doneTimesThisYear] / [self thisYearTimes] * 100;
    
    if ( percentDoneThis > PERCENT_100 ) percentDoneThis = PERCENT_100;
    
    return percentDoneThis;
}

- (BOOL)isInitialLaunchApp {
    NSArray    *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietNewOld];
    if ( [array count] == 0 ) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark ---------- Date & Day ----------
- (NSInteger)daysBetweenStartAndEnd:(NSDate *)start end:(NSDate *)end { // CAUTION! 10/1 ~ 10/3 ==> 2
    
    NSDate    *date_start = [self componentsYearMonthDay:start];
    NSDate    *date_end   = [self componentsYearMonthDay:end];
    
    if ( date_start == NULL && date_end == NULL ) {
        LOG_ERROR_METHOD;
        
        return 0;
    }
    
    NSDateComponents    *diff;
    NSCalendar          *calendar = [NSCalendar currentCalendar];
    diff = [calendar components:NSDayCalendarUnit fromDate:date_start toDate:date_end options:0];
    
    return [diff day];
}

- (NSInteger)blankDays {
    NSInteger    blank_days;
    
    NSArray      *array = [KSDietController sharedManager].sortedDietNewOld;
    KSDiet       *diet;
    
    if ( [array count] != FIRST_Object_OF_NSArray ) {
        
        diet = [array objectAtIndex:FIRST_Object_OF_NSArray];
        
        blank_days = [self daysBetweenStartAndEnd:[NSDate date] end:diet.today] - 1; // bank day is ex. 10/1 ~ 10/3 ==> 1
        if ( blank_days < 0 ) blank_days = 0;
        
    } else {
        NSLog(@"check Blank days");
        blank_days = 0;
    }
    
    diet  = nil;
    array = nil;
    
    return blank_days;
}

- (NSInteger)remainDays {
    
    NSArray      *array = [KSDietController sharedManager].sortedDietNewOld;
    KSDiet       *diet;
    
    NSInteger    remain_days = 0;
    
    if ( [array count] != FIRST_Object_OF_NSArray ) {
        
        diet = [array objectAtIndex:FIRST_Object_OF_NSArray];
        
        // error treat
        if ( diet.die_day == nil ) {
            diet.die_day = [NSDate date];
            //NSLog(@"die date has error, should add new code!");
        }
        
        remain_days = [self daysBetweenStartAndEnd:[NSDate date] end:diet.die_day];
        
    } else {
        NSLog(@"error ? check remain days");
        //remain_days = 0;
    }
    
    if ( diet.die_day == nil ) {
        diet.die_day = [NSDate date];
        //NSLog(@"die date has error, should add new code!");
    }
    
    remain_days = [self daysBetweenStartAndEnd:[NSDate date] end:diet.die_day];
    
    diet = nil;
    
    return remain_days;
}

- (NSDate *)componentsYearMonthDay:(NSDate *)comp_date {
    NSDateComponents    *dcomp = [self separateDateComponets:comp_date];
    
    NSCalendar          *calendar    = [NSCalendar currentCalendar];
    NSDateComponents    *compornents = [[NSDateComponents alloc]init];
    [compornents setYear:dcomp.year];
    [compornents setMonth:dcomp.month];
    [compornents setDay:dcomp.day];
    NSDate    *_date_ = [calendar dateFromComponents:compornents];
    
    return _date_;
}

- (NSDateComponents *)separateDateComponets:(NSDate *)date {
    // デフォルトのカレンダーを取得
    NSCalendar          *calendar = [NSCalendar currentCalendar];
    
    // 日時をカレンダーで年月日時分秒に分解する
    NSDateComponents    *dateComps = [calendar components:
                                      NSYearCalendarUnit   |
                                      NSMonthCalendarUnit  |
                                      NSDayCalendarUnit    |
                                      NSHourCalendarUnit   |
                                      NSMinuteCalendarUnit |
                                      NSSecondCalendarUnit
                                                 fromDate:date];
    
    //    NSLog(@"separateDateComponets:%d/%02d/%02d",  dateComps.year, dateComps.month, dateComps.day);
    
    return dateComps;
}

- (NSString *)displayDateFormatted:(NSDate *)date {
    NSDateComponents    *comp = [self separateDateComponets:date];
    
    return [NSString stringWithFormat:@"%d/%2d/%2d", comp.year, comp.month, comp.day];
}

- (BOOL)isNewestDate:(NSDate *)base newest:(NSDate *)newest {
    
    NSTimeInterval    since = [newest timeIntervalSinceDate:base];
    
    BOOL              isNewest;
    if ( since > 0 ) {
        NSLog(@"new one");
        isNewest = TRUE;
    } else {
        NSLog(@"%f", since);
        isNewest = FALSE;
    }
    
    return isNewest;
}

- (BOOL)isTodayData {
    
    //save された最新の日時
    KSDiet             *diet = [self newestData];
    NSDateFormatter    *df   = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd";
    
    NSString           *now_        = [df stringFromDate:[NSDate date]];
    NSString           *latestDate_ = [df stringFromDate:diet.today];
    
    bool               exist = NO;
    if ( [now_ isEqualToString:latestDate_] ) {
        exist = YES;
    } else {
        exist = NO;
    }
    
    return exist;
}

- (BOOL)isDataExist:(NSDate *)target {
    
    NSArray    *array = [KSDietController sharedManager].sortedDietNewOld;
    KSDiet     *searchDate;
    BOOL       exist = NO;
    
    for ( int i = 0; i < [array count]; i++ ) {
        searchDate = [array objectAtIndex:i];
        NSDate    *_search_ = [self componentsYearMonthDay:searchDate.today];
        NSDate    *_base_   = [self componentsYearMonthDay:target];
        
        exist = [_base_ isEqualToDate:_search_];
        if ( exist ) break;
        
    }
    
    return exist;
    
}

- (KSDiet *)newestData {
    NSArray    *array = [[NSArray alloc]initWithArray:[KSDietController sharedManager].sortedDietNewOld];
    KSDiet     *diet;
    
    if ( [array count] != FIRST_Object_OF_NSArray ) {
        diet = [array objectAtIndex:FIRST_Object_OF_NSArray];
    } else {
        NSLog(@"data not exist");
        diet = nil;
    }
    
    return diet;
}

- (NSInteger)thisYearComponents:(NSDate *)date {
    
    NSDateComponents    *today = [self separateDateComponets:date];
    
    return today.year;
}

- (BOOL)isLeapYear:(NSDate *)date {
    
    BOOL         result;
    
    // 取得した年が閏年かどうかを判定します。
    NSInteger    targetYear = [self thisYearComponents:date];
    if ( targetYear % 4 == 0 ) {
        if ( targetYear % 100 == 0 ) {
            if ( targetYear % 400 == 0 ) {
                result = YES;
            } else {
                result = NO;
            }
        } else {
            result = YES;
        }
    } else {
        result = NO;
    }
    
    return result;
}

#pragma mark -
#pragma mark ---------- Times ----------
- (NSInteger)thisYearTimes {
    int    days;
    
    if ( [self isLeapYear:[NSDate date]] ) {
        days = 366;
    } else {
        days = 365;
    }
    
    return (NSInteger)(days * DIET_TIMES_aDAY);
}

- (NSInteger)remainTimesThisYear {
    return [self thisYearTimes] - [self doneTimesThisYear];
}

- (NSInteger)remainTimesAll {
    
    NSInteger    times = ([self remainDays]) * DIET_TIMES_aDAY; //当日分は後で補正をかけるので−１しておく
    times += [self timesAdjustmentByTime:[NSDate date]];
    
    return times;
}

- (NSInteger)timesAdjustmentByTime:(NSDate *)date { //時間によって補正をかける

    NSInteger    hour  = [self separateDateComponets:date].hour;
    NSInteger    times = 0;

    
    if ( hour < LUNCH_TIME ) {
        times = 0;
    } else if ( hour >= LUNCH_TIME && hour < DINNER_TIME ) {
        times = -1;
    } else if ( hour >= DINNER_TIME ) {
        times = -2;
    }
    
    return times;
}

- (NSInteger)totalTimes {
    KSDiet     *diet;
    NSArray    *array = [KSDietController sharedManager].sortedDietNewOld;
    
    if ( [array count] != FIRST_Object_OF_NSArray ) {
        diet = [array objectAtIndex:FIRST_Object_OF_NSArray]; //最新の情報を得る
    } else {
        NSLog(@"Total times: array is null");
        
        return 0;
    }
    
    return ([self daysBetweenStartAndEnd:diet.bitrh_day end:diet.die_day] + 1) * DIET_TIMES_aDAY;
    
}

- (NSInteger)doneTimesThisYear {
    // NSCalendar を取得します。
    NSCalendar          *calendar = [NSCalendar currentCalendar];
    
    // NSDateComponents を作成して、そこに作成したい情報をセットします。
    NSDateComponents    *components = [[NSDateComponents alloc] init];
    
    components.year  = [self thisYearComponents:[NSDate date]];
    components.month = 1;
    components.day   = 1;
    
    // NSCalendar を使って、NSDateComponents を NSDate に変換します。
    NSDate       *FirstDayOfTheYear = [calendar dateFromComponents:components];
    
    NSInteger    times = ([self daysBetweenStartAndEnd:FirstDayOfTheYear end:[NSDate date]]) * DIET_TIMES_aDAY;
    
    //時間によって補正をかける
    times += [self timesAdjustmentByTime:[NSDate date]];
    
    return times;
}

- (NSInteger)doneTimesAll {
    
    KSDiet     *diet;
    NSArray    *array = [KSDietController sharedManager].sortedDietNewOld;
    
    if ( [array count] != FIRST_Object_OF_NSArray ) {
        diet = [array objectAtIndex:FIRST_Object_OF_NSArray]; //最新の情報を得る
    } else {
        NSLog(@"Total times: array is null");
        
        return 0;
    }
    
    NSInteger    time = ([self daysBetweenStartAndEnd:diet.bitrh_day end:[NSDate date]]) * DIET_TIMES_aDAY;
    time += (DIET_TIMES_aDAY - [self timesAdjustmentByTime:[NSDate date]]);
    
    return time;
    
}


#pragma mark -
#pragma mark ---------- age ----------
- (NSInteger)expectedAge {
    KSDiet       *diet = [self newestData];
    NSInteger    age_;
    if ( diet == NULL ) {
        age_ = 0;
        LOG_ERROR_METHOD;
        
    } else {
        age_ = [self expectedAge:diet.bitrh_day die:diet.die_day];
    }
    
    return age_;
    
}

- (NSInteger)expectedAge:(NSDate *)birth die:(NSDate *)die_day {
    
    NSInteger    age_;
    
    if ( birth == nil || die_day == nil ) {
        LOG_ERROR_METHOD;
        
        return 0;
    }
    
    NSDateComponents    *comp_birth = [self separateDateComponets:birth];
    NSDateComponents    *comp_die   = [self separateDateComponets:die_day];
    
    age_ = comp_die.year - comp_birth.year;
    
    return age_;
    
}

#pragma mark -
#pragma mark ---------- file name ----------
- (NSString *)stringConvertImgFileName:(NSString *)str {
    
    NSString    *meal_initial;
    if ( [str isEqualToString:@"n"] ) {
        meal_initial = NORMAL_FACE;
        
    } else if ( [str isEqualToString:@"g"] ) {
        meal_initial = GOOD_FACE;
        
    } else if ( [str isEqualToString:@"b"] ) {
        meal_initial = BAD_FACE;
        
    } else {
        
        meal_initial = NORMAL_FACE;
        
    }
    
    return meal_initial;
}

@end
