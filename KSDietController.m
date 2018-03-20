//
//  KSDietController.m
//  LastSupper
//
//  Created by 清水 一征 on 12/10/28.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import "KSDietController.h"

@implementation KSDietController

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

// 初期化
static KSDietController * _sharedInstance = nil;

+ (KSDietController *)sharedManager {
    if ( !_sharedInstance ) {
        _sharedInstance = [[KSDietController alloc]init];
    }
    
    return _sharedInstance;
}

//--------------------------------------------------------------//
#pragma mark -- プロパティ --
//--------------------------------------------------------------//

- (NSManagedObjectContext *)managedObjectContext {
    NSError    *error;
    
    // インスタンス変数のチェック
    
    if ( _managedObjectContext ) {
        return _managedObjectContext;
    }
    
    // 管理対象オブジェクトモデルの作成
    NSManagedObjectModel    *managedObjectModel;
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 永続ストアコーディネータの作成
    NSPersistentStoreCoordinator    *persistentStoreCoordinator;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:managedObjectModel];
    
    // 保存ファイルの決定
    NSArray     *paths;
    NSString    *path = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ( [paths count] > 0 ) {
        path = [paths objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@".diet"];
        path = [path stringByAppendingPathComponent:@"diet.db"];
    }
    
    if ( !path ) {
        return nil;
    }
    
    // ディレクトリの作成
    NSString         *dirPath;
    NSFileManager    *fileMgr;
    dirPath = [path stringByDeletingLastPathComponent];
    fileMgr = [NSFileManager defaultManager];
    if ( ![fileMgr fileExistsAtPath:dirPath] ) {
        if ( ![fileMgr  createDirectoryAtPath:dirPath
                  withIntermediateDirectories:YES attributes:nil error:&error] ) {
            NSLog(@"Failed to create directory at path %@, erro %@",
                  dirPath, [error localizedDescription]);
        }
    }
    
    // ストアURLの作成
    NSURL    *url = nil;
    url = [NSURL fileURLWithPath:path];
    
    // 永続ストアの追加
    NSPersistentStore    *persistentStore;
    persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil URL:url options:nil error:&error];
    if ( !persistentStore && error ) {
        NSLog(@"Failed to create add persitent store, %@", [error localizedDescription]);
    }
    
    // 管理対象オブジェクトコンテキストの作成
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    // 永続ストアコーディネータの設定
    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return _managedObjectContext;
}

- (NSArray *)sortedDietOldNew {
    // 管理対象オブジェクトコンテキストを取得する
    NSManagedObjectContext    *context;
    context = self.managedObjectContext;
    
    // 取得要求を作成する
    NSFetchRequest         *request;
    NSEntityDescription    *entity;
    NSSortDescriptor       *sortDescriptor;
    request = [[NSFetchRequest alloc] init];
    entity  = [NSEntityDescription entityForName:@"Diet" inManagedObjectContext:context];
    [request setEntity:entity];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"today" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    // 取得要求を実行する
    NSArray    *result;
    NSError    *error = nil;
    result = [context executeFetchRequest:request error:&error];
    if ( !result ) {
        // エラー
        NSLog(@"executeFetchRequest: failed, %@", [error localizedDescription]);
        
        return nil;
    }
    
    return result;
}

- (NSArray *)sortedDietNewOld {
    // 管理対象オブジェクトコンテキストを取得する
    NSManagedObjectContext    *context;
    context = self.managedObjectContext;
    
    // 取得要求を作成する
    NSFetchRequest         *request;
    NSEntityDescription    *entity;
    NSSortDescriptor       *sortDescriptor;
    request = [[NSFetchRequest alloc] init];
    entity  = [NSEntityDescription entityForName:@"Diet" inManagedObjectContext:context];
    [request setEntity:entity];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"today" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    // 取得要求を実行する
    NSArray    *result;
    NSError    *error = nil;
    result = [context executeFetchRequest:request error:&error];
    if ( !result ) {
        // エラー
        NSLog(@"executeFetchRequest: failed, %@", [error localizedDescription]);
        
        return nil;
    }
    
    return result;
    
}

//--------------------------------------------------------------//
#pragma mark -- アイテムの操作 --
//--------------------------------------------------------------//

// アイテムの操作
- (KSDiet *)insertNewDiet {
    NSManagedObjectContext    *context;
    context = self.managedObjectContext;
    
    KSDiet                    *diet;
    diet = [NSEntityDescription insertNewObjectForEntityForName:@"Diet" inManagedObjectContext:context];
    
    return diet;
}

//--------------------------------------------------------------//
#pragma mark -- 永続化 --
//--------------------------------------------------------------//

- (void)save {
    // 保存
    NSError    *error;
    if ( ![self.managedObjectContext save:&error] ) {
        // エラー
        NSLog(@"Error, %@", error);
    }
}

@end
