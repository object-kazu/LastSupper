//
//  KSTableViewController.h
//  LastSupper
//
//  Created by 清水 一征 on 12/10/25.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KSDiet.h"
#import "KSDietCell.h"
#import "def.h"
#import "KSCalc.h"
#import "KSEditViewController.h"

@interface KSTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController    *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext        *managedObjectContext;

@property (strong, nonatomic) UILabel                       *year;
@property (strong, nonatomic) UILabel                       *month_day;
@property (weak, nonatomic)  UIImageView                    *morning_img;
@property (weak, nonatomic)  UIImageView                    *lunch_img;
@property (weak, nonatomic)  UIImageView                    *dinner_img;
@property (strong, nonatomic) NSString                      *morning_score;
@property (strong, nonatomic) NSString                      *lunch_score;
@property (strong, nonatomic) NSString                      *dinner_score;

@property (strong, nonatomic) KSDiet                        *dietResults;
@property (strong, nonatomic) KSCalc                        *dateCalc;

//for return KSview
@property (nonatomic, weak) IBOutlet UIBarButtonItem        *backbutton;
- (IBAction)back;

// for edit view
@property (nonatomic, retain) NSIndexPath    *selectedIndexPath;

@end
