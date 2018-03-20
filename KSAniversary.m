//
//  KSAniversasy.m
//  LastSupper
//
//  Created by 清水 一征 on 13/05/02.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSAniversary.h"
#import "def.h"
#import "KSCalc.h"

@interface KSAniversary ()

@end

@implementation KSAniversary

- (id)init {
    if ( self = [super init] ) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark ---------- method ----------
- (NSDate *)appendDay:(NSDate *)baseDate DaysPlus:(NSInteger)days {
    
    NSDateComponents    *dateComp = [[NSDateComponents alloc] init];
    
    [dateComp setDay:days];
    
    NSDate    *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:baseDate options:0];
    
    dateComp = nil;
    
    return date;
    
}

- (NSDate *)indicateDate:(NSDate *)baseDate TimesPlus:(NSInteger)times {
    NSInteger           days = (NSInteger)(times / DIET_TIMES_aDAY);
    
    NSDateComponents    *dateComp = [NSDateComponents new];
    [dateComp setDay:days];
    NSDate              *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:baseDate options:0];
    
    dateComp = nil;
    
    return newDate;
    
}

- (NSString *)indicateDiet:(NSInteger)times {
    NSInteger    diet = times % DIET_TIMES_aDAY;
    //    NSLog(@"indicate diet %d",diet);
    //    DIET_TAGS    dtag;
    NSString     *str;
    switch ( diet ) {
        case 1:
            str = MORNINING;
            break;
            
        case 2:
            str = LUNCH;
            break;
            
        case 0:
            str = DINNER;
            break;
            
        default:
            LOG_ERROR_METHOD;
            str = @"ERROR";
            break;
    }
    
    return str;
}

- (NSArray *)daysAndDiet:(NSInteger)times {
    KSDiet          *diet;
    NSArray         *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietNewOld];
    KSAniversary    *ani   = [KSAniversary new];
    
    if ( [array count] > 0 ) {
        diet = [array objectAtIndex:FIRST_Object_OF_NSArray];
        
        NSDate     *date   = [ani indicateDate:diet.bitrh_day TimesPlus:times];
        NSArray    *result = [[NSArray alloc] initWithObjects:date, [self indicateDiet:times], nil];
        
        return result;
        
    } else {
        LOG_ERROR_METHOD;
        
        return nil;
    }
}

//attribute string
- (BOOL)isTodayOverAniversary:(NSDate *)aniversary {
    NSDate                *today = [NSDate date];
    NSComparisonResult    result = [today compare:aniversary];
    if ( result == NSOrderedDescending ) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark -
#pragma mark ---------- generation ----------

- (GENERATION_Tag)gtagManager:(GENERATION_Tag)tag plus:(BOOL)plus {
    GENERATION_Tag    temp_tag;
    
    if ( plus ) { // plus
        if ( tag == geneTag_max ) {
            temp_tag = geneTag_min;
        } else {
            temp_tag = (tag + 1);
        }
        
    } else { // minus
        if ( tag == geneTag_min ) {
            temp_tag = geneTag_min;
        } else {
            temp_tag = (tag - 1);
        }
        
    }
    
    return temp_tag;
}

- (NSInteger)generationTagConvertNSinteger:(GENERATION_Tag)generation {
    NSInteger    target = 0;
    switch ( generation ) {
        case geneTag_min:
            target = gene_min;
            break;
            
        case geneTag_10_you:
            target = gene_YOU;
            break;
            
        case geneTag_20_jyaku:
            target = gene_JYAKU;
            break;
        case geneTag_30_sou:
            target = gene_SOU;
            break;
        case geneTag_40_kyou:
            target = gene_KYOU;
            break;
        case geneTag_50_gai:
            target = gene_GAI;
            break;
        case geneTag_60_ki:
            target = gene_KI;
            break;
        case geneTag_70_rou:
            target = gene_ROU;
            break;
        case geneTag_80_mou:
            target = gene_MOU;
            break;
            
        default:
            target = gene_YOU;
            break;
    }
    
    return target;
}

- (GENERATION_Tag)dateConvertGeneration:(NSInteger)remainTimesAll {
    
    GENERATION_Tag    tag = geneTag_max;
    if ( remainTimesAll <= 10000 ) {
        tag = geneTag_min;
    }
    
    if ( remainTimesAll > 10000 && remainTimesAll <= 20000 ) {
        tag = geneTag_10_you;
    }
    
    if ( remainTimesAll > 20000 && remainTimesAll <= 30000 ) {
        tag = geneTag_20_jyaku;
    }
    
    if ( remainTimesAll > 30000 && remainTimesAll <= 40000 ) {
        tag = geneTag_30_sou;
    }
    
    if ( remainTimesAll > 40000 && remainTimesAll <= 50000 ) {
        tag = geneTag_40_kyou;
    }
    
    if ( remainTimesAll > 50000 && remainTimesAll <= 60000 ) {
        tag = geneTag_50_gai;
    }
    
    if ( remainTimesAll > 60000 && remainTimesAll <= 70000 ) {
        tag = geneTag_60_ki;
    }
    
    if ( remainTimesAll > 70000 && remainTimesAll <= 80000 ) {
        tag = geneTag_70_rou;
    }
    
    if ( remainTimesAll > 80000 && remainTimesAll <= 90000 ) {
        tag = geneTag_80_mou;
    }
    
    return tag;
}

@end
