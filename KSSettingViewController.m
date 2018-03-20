//
//  KSSettingViewController.m
//  LastSupper
//
//  Created by 清水 一征 on 12/11/05.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import "KSSettingViewController.h"
#import "KSCalc.h"
#import "def.h"
#import "KSColor.h"
#import <QuartzCore/QuartzCore.h>

#define BACKTOMAIN @"Back"

@interface KSSettingViewController ()

- (void)birthday_setting;
- (void)dieDay_setting;
- (void)save_setting;
- (void)showDateAlert;
- (void)displayArrow;
- (void)changeDoneButtonText;
- (void)setBackgroundColor;

@end

@implementation KSSettingViewController
@synthesize label_birth;
@synthesize label_die;
@synthesize label_age;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doneButton.enabled = YES;
    self.doneButton.title   = [NSString stringWithFormat:BACKTOMAIN];
    self.allowImg.hidden    = YES;
    
    self.label_birth.textColor   = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    self.label_die.textColor     = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    self.birthdayValue.textColor = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    self.dieDayValue.textColor   = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    
    _birthday_stock = nil;
    _dieDay_stock   = nil;
    
    //date picker display init value
    KSDiet       *preDiet;
    KSCalc       *calc = [[KSCalc alloc]init];
    preDiet = [calc newestData];
    NSString     *str_b, *str_d;
    NSInteger    age_;
    
    if ( preDiet == nil ) { //data not exist
        NSDate    *today = [NSDate date];
        str_b = [calc displayDateFormatted:today];
        str_d = [calc displayDateFormatted:today];
        age_  = 0;
        
    } else { //data exist
        _birthday_stock = preDiet.bitrh_day;
        _dieDay_stock   = preDiet.die_day;
        
        str_b = [calc displayDateFormatted:_birthday_stock];
        str_d = [calc displayDateFormatted:_dieDay_stock];
        age_  = [calc expectedAge];
        
    }
    
    _birthdayValue.text = [NSString stringWithFormat:@"%@", str_b];
    _dieDayValue.text   = [NSString stringWithFormat:@"%@", str_d];
    self.label_age.text = [NSString stringWithFormat:@"%i", age_];
    
    _birthdayValue.textColor = [UIColor grayColor];
    _dieDayValue.textColor   = [UIColor grayColor];
    
    self.selectionDays.selectedSegmentIndex = INDEX_BIRTH;
    
    [_datePick addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
    
    [self setBackgroundColor];
    
    calc = nil;
}


- (void)setBackgroundColor {
    
    //backgroung color
    CAGradientLayer    *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    
    KSColor            *_color = [[KSColor alloc]init];
    gradient.colors = [_color gradient_colors_back];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    _color = nil;
    
}

- (void)changeDoneButtonText {
    
    if ( [self.doneButton.title isEqualToString:BACKTOMAIN] ) {
        self.doneButton.title   = [NSString stringWithFormat:@"Done"];
        self.doneButton.enabled = NO;
    }
}

- (IBAction)dateDetermin {
    
    [self changeDoneButtonText];
    //NSLog(@"dateDetermin called");
    NSDate    *now = [NSDate date];
    
    KSCalc    *calc = [[KSCalc alloc] init];
    
    if ( self.selectionDays.selectedSegmentIndex == INDEX_BIRTH ) {
        
        _birthdayValue.text                     = [calc displayDateFormatted:self.datePick.date];
        _birthday_stock                         = self.datePick.date;
        _birthdayValue.textColor                = [UIColor redColor];
        self.label_birth.textColor              = [UIColor blackColor];
        self.selectionDays.selectedSegmentIndex = INDEX_DIE;
        self.datePick.date                      = now;
        
    } else if ( self.selectionDays.selectedSegmentIndex == INDEX_DIE ) {
        
        _dieDayValue.text                       = [calc displayDateFormatted:self.datePick.date];
        _dieDay_stock                           = self.datePick.date;
        _dieDayValue.textColor                  = [UIColor redColor];
        self.label_die.textColor                = [UIColor blackColor];
        self.selectionDays.selectedSegmentIndex = INDEX_BIRTH;
        
        if ( _birthday_stock != nil && _dieDay_stock != nil ) {
            
            if ( [calc isNewestDate:_birthday_stock newest:_dieDay_stock] ) {
                [self save_setting];
                self.doneButton.enabled = YES;
                [self displayArrow];
            } else {
                [self showDateAlert];
            }
            
        } else {
            //error treatment
            NSLog(@"dateDetermin has error");
        }
        
    }
    
    calc = nil;
    
}

- (void)displayArrow {
    self.allowImg.hidden = NO;
    
    CGRect    screen = [[UIScreen mainScreen] bounds];
    //    NSLog(@"screen size width:%f",screen.size.width);
    float     btn_x  = screen.size.width * 0.9;
    float     btn_y1 = screen.size.height * 0.85;
    float     btn_y2 = screen.size.height * 0.80;
    
    [UIImageView animateWithDuration:1.0f
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseOut
     | UIViewAnimationOptionRepeat
                          animations:^{
                              self.allowImg.center = CGPointMake(btn_x, btn_y2);
                              self.allowImg.center = CGPointMake(btn_x, btn_y1);
                              
                          }
     
                          completion:nil];
    
}

- (void)showDateAlert {
    UIAlertView    *alert = [[UIAlertView alloc]
                             initWithTitle:@"設定を見なおしてください"
                             message:@""
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
    [alert show];
    
}

- (void)save_setting {
    //updata or save new
    
    KSDiet    *newDiet;
    KSCalc    *calc = [[KSCalc alloc]init];
    newDiet = [calc newestData];
    
    if ( newDiet == nil ) { //data がない場合
        //save
        newDiet       = [[KSDietController sharedManager] insertNewDiet];
        newDiet.today = [NSDate date];
        
    } else if ( ![calc isTodayData] ) { //data is new!
        //save
        newDiet       = [[KSDietController sharedManager] insertNewDiet];
        newDiet.today = [NSDate date];
        
    } else { // data already is existed
        //update
        
    }
    
    newDiet.bitrh_day = _birthday_stock;
    newDiet.die_day   = _dieDay_stock;
    
    [[KSDietController sharedManager] save];
    
    calc = nil;
}

- (IBAction)segmentControllIndexChanged:(id)sender {
    
    switch ( self.selectionDays.selectedSegmentIndex ) {
            
        case INDEX_BIRTH:
            [self birthday_setting];
            break;
        case INDEX_DIE:
            [self dieDay_setting];
            
            break;
        default:
            NSLog(@"error at segmentControllIndexChange");
            break;
    }
}

- (void)birthday_setting {
    _birthdayValue.textColor = [UIColor redColor];
}

- (void)dieDay_setting {
    _dieDayValue.textColor = [UIColor redColor];
    
}

- (IBAction)changeDate {
    
    KSCalc       *calc = [[KSCalc alloc] init];
    NSInteger    _age_ = 0;
    
    if ( self.selectionDays.selectedSegmentIndex == INDEX_BIRTH ) {
        _age_ = 0;
    } else if ( self.selectionDays.selectedSegmentIndex == INDEX_DIE ) {
        _age_ =   _age_ = [calc expectedAge:_birthday_stock die:self.datePick.date];
    } else {
        _age_ = -10000;
        //NSLog(@"Error !!!");
        LOG_ERROR_METHOD;
    }
    
    if ( _age_ < 0 ) _age_ = 0;
    self.label_age.text = [NSString stringWithFormat:@"%d", _age_];
    
    calc = nil;
    
}

- (IBAction)doneSetting {
    
    if ( ![self isBeingDismissed] ) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (void)didReceiveMemoryWarning {
    
    NSLog(@"didReceioveMemoryWarning call");
    
    [super didReceiveMemoryWarning];
    if ( [self.view window] == nil ) {
        
    }
}

- (void)viewDidUnload {
    [self setDatePick:nil];
    [self setSelectionDays:nil];
    [self setDoneButton:nil];
    [self setAllowImg:nil];
    [self setLabel_birth:nil];
    [self setLabel_die:nil];
    [self setLabel_age:nil];
    [super viewDidUnload];
}

@end
