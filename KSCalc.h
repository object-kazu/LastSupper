//
//  KSCalc.h
//  LastSupper
//
//  Created by 清水 一征 on 12/11/04.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDiet.h"
#import "KSDietController.h"

@interface KSCalc : NSObject

@property (nonatomic) float    percentRemainAll;
@property (nonatomic) float    percentRemainThisYear;
@property (nonatomic) float    percentDoneAll;
@property (nonatomic) float    percentDoneThisYear;
@property (nonatomic) BOOL     isInitialLaunchApp;

- (NSInteger)blankDays;
- (NSInteger)remainDays;
- (NSInteger)thisYearComponents:(NSDate *)date;
- (NSInteger)remainTimesAll;
- (NSInteger)remainTimesThisYear;
- (NSInteger)doneTimesAll;
- (NSInteger)doneTimesThisYear;
- (NSInteger)totalTimes;
- (NSInteger)thisYearTimes;
- (NSDateComponents *)separateDateComponets:(NSDate *)date;
- (NSDate *)componentsYearMonthDay:(NSDate *)comp_date;
- (NSString *)displayDateFormatted:(NSDate *)date;
- (BOOL)isNewestDate:(NSDate *)base newest:(NSDate *)newest;
- (KSDiet *)newestData;
- (BOOL)isTodayData;
- (NSInteger)expectedAge;
- (NSInteger)expectedAge:(NSDate *)birth die:(NSDate *)die_day;
- (BOOL)isDataExist:(NSDate *)target;
- (NSString *)stringConvertImgFileName:(NSString *)str;

// private でいいけどテストのために外に出した
- (NSInteger)daysBetweenStartAndEnd:(NSDate *)start end:(NSDate *)end;
- (NSInteger)timesAdjustmentByTime:(NSDate *)date;
- (BOOL)isLeapYear:(NSDate *)date;

@end
