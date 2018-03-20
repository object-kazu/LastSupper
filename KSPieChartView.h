//
//  KSPieChartView.h
//  pieChartTest
//
//  Created by 清水 一征 on 13/03/09.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (int, ITEM) {
    DONE = 0,
    DONE_THIS,
    REMAIN_THIS,
    REMAIN,
    ITEM_MAX
    
};

@interface KSPieChartView : UIView

@property (nonatomic) CGFloat    DoneValue;
@property (nonatomic) CGFloat    DoneThisValue;
@property (nonatomic) CGFloat    RemainValue;
@property (nonatomic) CGFloat    RemainThisValue;
@property (nonatomic) CGPoint    center;

@property (nonatomic) CGFloat    radius;

- (void)setColor:(int)item r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

@end
