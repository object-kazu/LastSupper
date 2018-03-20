//
//  KSViewController.h
//  LastSupper
//
//  Created by 清水 一征 on 12/10/24.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDietController.h"
#import "KSDiet.h"
#import "KSImage.h"
#import "KSMasterViewController.h"

@interface KSViewController : KSMasterViewController

//aniversary
@property (nonatomic, weak) IBOutlet UIBarButtonItem     *modal_aniversary;

// meal image
@property (weak, nonatomic) IBOutlet UIImageView         *morning_image;
@property (weak, nonatomic) IBOutlet UIImageView         *lunch_image;
@property (weak, nonatomic) IBOutlet UIImageView         *dinner_image;
@property (nonatomic, strong) KSImage                    *ks_img;

//touch
@property (nonatomic) NSInteger                          imageOrder;
@property (nonatomic) CGPoint                            startPoint;
@property (nonatomic) CGPoint                            endPoint;

@property (weak, nonatomic) IBOutlet UILabel             *dayFromLastSupper;
@property (weak, nonatomic) IBOutlet UILabel             *morning;
@property (weak, nonatomic) IBOutlet UILabel             *lunch;
@property (weak, nonatomic) IBOutlet UILabel             *dinner;
@property (weak, nonatomic) IBOutlet UILabel             *percentRemainAll;
@property (weak, nonatomic) IBOutlet UILabel             *percentRemainThisYear;
@property (weak, nonatomic) IBOutlet UILabel             *label_total;
@property (weak, nonatomic) IBOutlet UILabel             *label_year;
@property (weak, nonatomic) IBOutlet UILabel             *today;
@property (weak, nonatomic) IBOutlet UIBarButtonItem     *recordButton;
@property (nonatomic, weak) IBOutlet UILabel             *actionIndicator;

@property (nonatomic) float                              percentValue;
@property (nonatomic) float                              percentForThisYear;
@property (strong, nonatomic) NSDate                     *targetDay;
@property (strong, nonatomic) NSTimer                    *timer;
@property (strong, nonatomic) NSString                   *normal_state;
@property (strong, nonatomic) NSString                   *good_state;
@property (strong, nonatomic) NSString                   *bad_state;
@property (strong, nonatomic) UIActivityIndicatorView    *indicator;

//save and load
@property (nonatomic) NSInteger                          morning_state;
@property (nonatomic) NSInteger                          lunch_state;
@property (nonatomic) NSInteger                          dinner_state;
@property (nonatomic, retain) NSDate                     *birthday;
@property (nonatomic, retain) NSDate                     *die_day;
@property (nonatomic, retain) NSManagedObjectContext     *managedContext;
@property (strong, nonatomic) KSDiet                     *diet;
@property (weak, nonatomic) IBOutlet UIImageView         *allowImg;

- (IBAction)save;
- (void)toggleItem:(int)tag;
- (void)noticeCenter;
- (IBAction)modalAndSave;
- (IBAction)showAniversary;

@end
