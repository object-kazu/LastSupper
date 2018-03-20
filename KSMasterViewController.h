//
//  KSMasterViewController.h
//  LastSupper
//
//  Created by 清水 一征 on 13/05/26.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCalc.h"
#import "def.h"
#import <QuartzCore/QuartzCore.h>
#import "KSColor.h"

@interface KSMasterViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (BOOL)is568h;

- (void)setBackgroundColor;
- (void)photoLib:(NSString *)src;


@end
