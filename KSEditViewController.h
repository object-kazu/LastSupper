//
//  KSEditViewController.h
//  LastSupper
//
//  Created by 清水 一征 on 13/03/02.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSTableViewController.h"
#import "KSCalc.h"
#import "KSFaceMarkManager.h"
#import "KSImage.h"
#import "KSMasterViewController.h"

@interface KSEditViewController : KSMasterViewController

+ (KSEditViewController *)sharedManager;

@property (nonatomic, weak) IBOutlet UILabel            *editingDate;
@property (nonatomic, weak) IBOutlet UILabel            *morning;
@property (nonatomic, weak) IBOutlet UILabel            *lunch;
@property (nonatomic, weak) IBOutlet UILabel            *dinner;

@property (nonatomic, weak) IBOutlet UIBarButtonItem    *editing_done;

@property (nonatomic, weak) IBOutlet UIImageView        *morning_image;
@property (nonatomic, weak) IBOutlet UIImageView        *lunch_image;
@property (nonatomic, weak) IBOutlet UIImageView        *dinner_image;

////touch
@property (nonatomic) NSInteger                         imageOrder;
@property (nonatomic) CGPoint                           startPoint;
@property (nonatomic) CGPoint                           endPoint;

//save
@property (nonatomic, retain) KSDiet                    *editDiet;
@property (nonatomic, retain) NSIndexPath               *selectedIndexPath;
@property (nonatomic) NSInteger                         morning_state;
@property (nonatomic) NSInteger                         lunch_state;
@property (nonatomic) NSInteger                         dinner_state;
@property (nonatomic, retain) NSDate                    *birthday;
@property (nonatomic, retain) NSDate                    *die_day;
@property (nonatomic, strong) NSData                    *mData;
@property (nonatomic, strong) NSData                    *lData;
@property (nonatomic, strong) NSData                    *dData;

- (IBAction)editingDone;

@end
