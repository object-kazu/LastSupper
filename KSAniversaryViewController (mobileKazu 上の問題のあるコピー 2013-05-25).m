//
//  KSAniversaryViewController.m
//  LastSupper
//
//  Created by 清水 一征 on 13/05/02.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSAniversaryViewController.h"
#import "KSDietController.h"
#import "KSAniversary.h"
#import "def.h"
#import "KSCalc.h"

//title
#define fontName_title  @"Helvetica-BoldOblique"
#define TITLE_hight     50

// label
#define fontName_label  @"Helvetica"
#define Label_height    25
#define Label_wide      190
#define Label_font_size 18
#define Label_color     0.5
#define Label_alpha     0.9
#define Page_Tag        111

typedef NS_ENUM(NSInteger, SWIPE_DIRECTION) {
    swipe_left,
    swipe_right,
    swipe_max
};


@interface KSAniversaryViewController ()

@property (nonatomic) UILabel           *viewtitle;
@property (nonatomic) CGFloat           centerOfView;
@property (nonatomic) GENERATION_Tag    generationTag;

- (UILabel *)prep_times_label:(NSInteger)times;
- (UILabel *)prep_title_label:(NSInteger)times;
- (UIView *)prep_Page;
- (void)page:(UIView *)pageView generation:(GENERATION_Tag)generation;
-(void) swipeTransition:(SWIPE_DIRECTION)direction;


@end

@implementation KSAniversaryViewController

- (CGFloat)centerOfView {
    CGRect    screen = [[UIScreen mainScreen] bounds ];
    
    return screen.size.width / 2;
}

#pragma mark -
#pragma mark ---------- life cycle ----------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self ) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // generation tag init
    _generationTag = geneTag_max;
    
    // position variable
    CGRect    screen = [[UIScreen mainScreen] bounds];
    
    //title
    _viewtitle                 = [UILabel new];
    _viewtitle.frame           = CGRectMake(0, 0, screen.size.width, TITLE_hight);
    _viewtitle.text            = @"ANIVERSARY";
    _viewtitle.font            = [UIFont fontWithName:fontName_title size:40];
    _viewtitle.textAlignment   = NSTextAlignmentCenter;
    _viewtitle.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_viewtitle];
    _viewtitle = nil;
    
    //page
    _generationTag = geneTag_10_you;
    UIView    *pageInit = [self prep_Page];
    [self.view addSubview:pageInit];
    [self page:pageInit generation:_generationTag];
    pageInit = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _title_label = nil;
    _times_label = nil;
}

- (void)back {
    //画面遷移
    if ( ![self isBeingDismissed] ) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark -
#pragma mark ---------- page ----------
- (UIView *)prep_Page {
    _pageView = [UIView new];
    CGRect    screen = [[UIScreen mainScreen] bounds];
    _pageView.frame                  = CGRectMake(0, TITLE_hight, screen.size.width, screen.size.height - TITLE_hight - 64);
    _pageView.backgroundColor        = [UIColor yellowColor];
    _pageView.userInteractionEnabled = YES;
    _pageView.tag = Page_Tag;
    
    UISwipeGestureRecognizer    *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(didSwipView:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.pageView addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture           = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipView:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.pageView addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    return _pageView;
}


- (void)page:(UIView *)pageView generation:(GENERATION_Tag)generation {

    NSMutableArray    *titlelabelArray = [NSMutableArray new];
    NSMutableArray    *timesArray      = [NSMutableArray new];
    
    // generation tag convert to NSinteger
    KSAniversary* ani = [KSAniversary new];
    NSInteger generatoionValue = [ani generationTagConvertNSinteger:generation];
    ani = nil;
    
    
    
    // layout parameters
    CGFloat           Label_position_x =    10;
    CGFloat           Label_position_y =    10;
    int               itemInPage          = 10;
    int               space_of_titleLabel = 0;
    float             aniversaryConstant  = 1.0;
    CGFloat           margin              = 7;
    int               generationConstant  = 1000;
    NSInteger         generationStep      = generatoionValue * generationConstant;
    
    //label prep
    for ( int i = 0; i < itemInPage; i++ ) {
        _times_label = [UILabel new];
        [timesArray addObject:_times_label];
        
        _title_label = [UILabel new];
        [titlelabelArray addObject:_title_label];
        
    }
    
    //label display
    for ( UILabel *__strong label in titlelabelArray ) {
        label                = [self prep_title_label:aniversaryConstant * generationStep];
        label.frame          = CGRectMake(Label_position_x, Label_position_y + space_of_titleLabel, Label_wide, Label_height);
        space_of_titleLabel += Label_font_size + Label_font_size + margin;
        [pageView addSubview:label];
        
        aniversaryConstant++;
        
    }
    
    aniversaryConstant = 1.0;
    int    space_of_timesLabel = Label_font_size;
    
    for ( UILabel *__strong label in timesArray ) {
        label       = [self prep_times_label:(aniversaryConstant * generationStep)];
        label.frame = CGRectMake(self.centerOfView - (Label_wide * 0.5), Label_position_y + space_of_timesLabel, Label_wide, Label_height);
        [self attributingLabel:label];
        [pageView addSubview:label];
        space_of_timesLabel += Label_font_size + Label_font_size + margin;
        aniversaryConstant++;
    }
    
    titlelabelArray = nil;
    timesArray      = nil;
    
}

#pragma mark -
#pragma mark ---------- swipe ----------

- (void)didSwipView:(UISwipeGestureRecognizer *)swipe {
    KSAniversary * ani = [KSAniversary new];
    
    if ( swipe.direction == UISwipeGestureRecognizerDirectionLeft ) {
        _generationTag = [ani gtagManager:_generationTag plus:YES];
        [self swipeTransition:swipe_left];


    } else if ( swipe.direction == UISwipeGestureRecognizerDirectionRight ) {
        _generationTag = [ani gtagManager:_generationTag plus:NO];
        [self swipeTransition:swipe_right];
    
    } else {
        
    }
  
}

-(void) swipeTransition:(SWIPE_DIRECTION)direction{
   
    UIView *oldview = [self.view viewWithTag:Page_Tag];
    CGFloat ori_y = oldview.frame.origin.y;
    CGFloat ori_width = oldview.frame.size.width;
    CGFloat ori_height = oldview.frame.size.height;
    
    UIView* newPage = [self prep_Page];
    newPage.frame = CGRectMake(ori_width, ori_y, ori_width, ori_height);
    [self.view addSubview:newPage];
    [self page:newPage generation:_generationTag];
    newPage.alpha = 0;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        
                         if (direction == swipe_left) {
                             oldview.frame = CGRectMake(-1 * ori_width, ori_y, ori_width, ori_height);
                         }else if (direction == swipe_right){
                             oldview.frame = CGRectMake( ori_width, ori_y, ori_width, ori_height);
                             
                         }
                         oldview.alpha = 0;

                         
                     } completion:^(BOOL finished) {
                         [oldview removeFromSuperview];
                         
                         [UIView animateWithDuration:0.3f
                                               delay:0.1f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              newPage.alpha = 1.0f;
                                              newPage.frame = CGRectMake(0, ori_y, ori_width, ori_height);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                         
                     }];
     newPage = nil;

    
  
}

#pragma mark -
#pragma mark ---------- attribute label ----------

- (void)attributingLabel:(UILabel *)label {
    if ( label.text != nil && _isTodayOverAniversary ) {
        
        NSMutableAttributedString    *attStr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attStr addAttribute:NSStrikethroughStyleAttributeName
                       value:[NSNumber numberWithInt:1]
                       range:NSMakeRange(0, [label.text length])];
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:RGBA(232, 122, 144, 0.7)
                       range:NSMakeRange(0, [label.text length])];
        
        [label setAttributedText:attStr];
    }
}

#pragma mark -
#pragma mark ---------- display label ----------

- (UILabel *)prep_times_label:(NSInteger)times {
    UILabel    *label = [UILabel new];
    label.frame           = CGRectZero;
    label.font            = [UIFont fontWithName:fontName_label size:Label_font_size];
    label.textColor       = [UIColor colorWithWhite:Label_color alpha:Label_alpha];
    label.backgroundColor = [UIColor clearColor];
    
    KSAniversary    *aniversary = [KSAniversary new];
    NSArray         *arr        = [aniversary daysAndDiet:times];
    
    NSString        *str;
    KSCalc          *calc = [KSCalc new];
    if ( [arr count] != 2 ) str = @"error";
    NSDate          *targetDate = [arr objectAtIndex:INDEX_DATE];
    
    if ( [aniversary isTodayOverAniversary:targetDate] ) {
        _isTodayOverAniversary = YES;
    } else {
        _isTodayOverAniversary = NO;
    }
    
    NSString    *date = [calc displayDateFormatted:targetDate];
    str        = [NSString stringWithFormat:@"%@ :%@", date, [arr objectAtIndex:INDEX_DIET]];
    label.text = str;
    calc       = nil;
    
    return label;
    
}

- (UILabel *)prep_title_label:(NSInteger)times {
    UILabel    *label = [UILabel new];
    label.frame           = CGRectZero;
    label.font            = [UIFont fontWithName:fontName_label size:Label_font_size];
    label.textColor       = [UIColor colorWithWhite:Label_color alpha:Label_alpha];
    label.backgroundColor = [UIColor clearColor];
    
    NSString    *str = [NSString stringWithFormat:@"%d", times];
    label.text = str;
    
    return label;
    
}

@end
