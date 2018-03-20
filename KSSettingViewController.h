//
//  KSSettingViewController.h
//  LastSupper
//
//  Created by 清水 一征 on 12/11/05.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "KSDietController.h"

@interface KSSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel               *label_birth;
@property (weak, nonatomic) IBOutlet UILabel               *label_die;
@property (weak, nonatomic) IBOutlet UILabel               *label_age;

@property (weak, nonatomic) IBOutlet UILabel               *birthdayValue;
@property (weak, nonatomic) IBOutlet UILabel               *dieDayValue;
@property (weak, nonatomic) IBOutlet UIDatePicker          *datePick;
@property (weak, nonatomic) IBOutlet UIButton              *setValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl    *selectionDays;
@property (weak, nonatomic) IBOutlet UIBarButtonItem       *doneButton;
@property (strong, nonatomic) NSDate                       *birthday_stock;
@property (strong, nonatomic) NSDate                       *dieDay_stock;
@property (weak, nonatomic) IBOutlet UIImageView           *allowImg;

- (IBAction)dateDetermin;
- (IBAction)segmentControllIndexChanged:(id)sender;
- (IBAction)changeDate;
- (IBAction)doneSetting;

@end
