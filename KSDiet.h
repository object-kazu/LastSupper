//
//  KSDiet.h
//  LastSupper
//
//  Created by 清水 一征 on 12/10/29.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KSDiet : NSManagedObject

@property (nonatomic, retain) NSDate * bitrh_day;
@property (nonatomic, retain) NSDate * die_day;
@property (nonatomic, retain) NSString * dinner;
@property (nonatomic, retain) NSString * lunch;
@property (nonatomic, retain) NSString * morning;
@property (nonatomic, retain) NSDate * today;
@property (nonatomic, retain) NSData* thumbnail_morning;
@property (nonatomic, retain) NSData* thumbnail_lunch;
@property (nonatomic, retain) NSData* thumbnail_dinner;


@end
