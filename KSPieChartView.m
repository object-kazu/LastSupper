//
//  KSPieChartView.m
//  pieChartTest
//
//  Created by 清水 一征 on 13/03/09.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSPieChartView.h"

static inline float radians(double degrees) {
    return degrees * M_PI / 180.0;
}

@interface KSPieChartView ()

@property (nonatomic) CGFloat    itemAFinish;

@property (nonatomic) CGFloat    cAr, cAg, cAb, cAa;
@property (nonatomic) CGFloat    cBr, cBg, cBb, cBa;
@property (nonatomic) CGFloat    cCr, cCg, cCb, cCa;
@property (nonatomic) CGFloat    cDr, cDg, cDb, cDa;


- (CGFloat)regulate255:(CGFloat)FLOAT;

//-(void) shadowSetting;

@end

@implementation KSPieChartView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        // Initialization code
        _DoneValue = _DoneThisValue = _RemainValue = _RemainThisValue = 0;
        
        _radius = 100; // 半径
        
        // 中心座標の取得
        CGFloat    x = CGRectGetWidth(self.bounds) / 2.0;
        CGFloat    y = CGRectGetHeight(self.bounds) / 2.0;
        self.center = CGPointMake(x, y);
        
        _cAa = _cAr = _cAg = _cAb = 1.0f;
        _cBa = _cBr = _cBg = _cBb = 1.0f;
        _cCa = _cCr = _cCg = _cCb = 1.0f;
        _cDa = _cDr = _cDg = _cDb = 1.0f;
        
    }
    
    return self;
}

//今回versionでは使用しない
//-(void) shadowSetting{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // 影の描画
//    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]));
//    CGContextMoveToPoint(context, _center.x, _center.y);
//    CGContextAddArc(context, _center.x + 2.0, _center.y + 2.0, _radius,  radians(0.0), radians(360.0), 0.0);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//
//}

- (CGFloat)regulate255:(CGFloat)FLOAT {
    return (CGFloat)FLOAT / 255;
}

- (void)setColor:(int)item r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
    switch ( item ) {
        case DONE:
            _cAr = [self regulate255:r];
            _cAg = [self regulate255:g];
            _cAb = [self regulate255:b];
            _cAa = a;
            break;
        case REMAIN:
            _cBr = [self regulate255:r];
            _cBg = [self regulate255:g];
            _cBb = [self regulate255:b];
            _cBa = a;
            break;
        case DONE_THIS:
            _cCr = [self regulate255:r];
            _cCg = [self regulate255:g];
            _cCb = [self regulate255:b];
            _cCa = a;
            break;
        case REMAIN_THIS:
            _cDr = [self regulate255:r];
            _cDg = [self regulate255:g];
            _cDb = [self regulate255:b];
            _cDa = a;
            break;
            
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect {
    
    // 描画開始位置
    CGFloat         start = -90.0;
    
    // 各項目の割合を取得
    CGFloat         allItems = _DoneValue + _DoneThisValue + _RemainValue + _RemainThisValue;
    
    _itemAFinish = _DoneValue * 360.0f / allItems;
    CGFloat         itemBFinish = _DoneThisValue * 360.0f / allItems;
    CGFloat         itemCFinish = _RemainValue * 360.0f / allItems;
    CGFloat         itemDFinish = _RemainThisValue * 360.0f / allItems;
    
    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    // 円グラフの描画
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:_cAr green:_cAg blue:_cAb alpha:_cAa] CGColor]));
    CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc(context, self.center.x, self.center.y, _radius,  radians(start), radians(start + _itemAFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:_cBr green:_cBg blue:_cBb alpha:_cBa] CGColor]));
    CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc(context, self.center.x, self.center.y, _radius,  radians(start + _itemAFinish), radians(start + _itemAFinish + itemBFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:_cCr green:_cCg blue:_cCb alpha:_cCa] CGColor]));
    CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc(context, self.center.x, self.center.y, _radius,  radians(start + _itemAFinish + itemBFinish), radians(start + _itemAFinish + itemBFinish + itemCFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:_cDr green:_cDg blue:_cDb alpha:_cDa] CGColor]));
    CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc(context, self.center.x, self.center.y, _radius,  radians(start + _itemAFinish + itemBFinish + itemCFinish), radians(start + _itemAFinish + itemBFinish + itemCFinish + itemDFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end
