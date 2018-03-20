//
//  KSDietCell.h
//  LastSupper
//
//  Created by 清水 一征 on 12/10/31.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSDietCell : UITableViewCell

// プロパティ
@property (nonatomic, retain) UILabel        *yearLabel;
@property (nonatomic, retain) UILabel        *monthAndDayLabel;
@property (nonatomic, retain) UILabel        *morningLabel;
@property (nonatomic, retain) UILabel        *lunchLabel;
@property (nonatomic, retain) UILabel        *dinnerLabel;
@property (nonatomic, retain) UIImageView    *morningImage;
@property (nonatomic, retain) UIImageView    *lunchImage;
@property (nonatomic, retain) UIImageView    *dinnerImage;

//hidden variable
@property (nonatomic, strong) NSDate         *editDay;
@property (nonatomic, strong) NSDate         *editBirth;
@property (nonatomic, strong) NSDate         *editDie;
@property (nonatomic, strong) NSString       *edit_morning;
@property (nonatomic, strong) NSString       *edit_lunch;
@property (nonatomic, strong) NSString       *edit_dinner;
@property (nonatomic, retain) NSData         *edit_t_morning;
@property (nonatomic, retain) NSData         *edit_t_lunch;
@property (nonatomic, retain) NSData         *edit_t_dinner;

@end
