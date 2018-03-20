//
//  KSDietController.h
//  LastSupper
//
//  Created by 清水 一征 on 12/10/28.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "KSDiet.h"

@interface KSDietController : NSObject
{
    NSManagedObjectContext    *_managedObjectContext;
}

// プロパティ
@property (nonatomic, readonly) NSManagedObjectContext    *managedObjectContext;
@property (nonatomic, readonly) NSArray                   *sortedDietOldNew;
@property (nonatomic, readonly) NSArray                   *sortedDietNewOld;
// 初期化
+ (KSDietController *)sharedManager;

// アイテムの操作
- (KSDiet *)insertNewDiet;

// 永続化
- (void)save;

@end
