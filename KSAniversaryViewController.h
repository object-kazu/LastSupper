//
//  KSAniversaryViewController.h
//  LastSupper
//
//  Created by 清水 一征 on 13/05/02.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "def.h"
#import "KSMasterViewController.h"

@interface KSAniversaryViewController : KSMasterViewController

@property (nonatomic, retain) UILabel    *title_label;
@property (nonatomic, retain) UILabel    *times_label;
@property (nonatomic, retain) UIView     *pageView;
@property (nonatomic) BOOL               isTodayOverAniversary;

- (void)attributingLabel:(UILabel *)label;

@end
