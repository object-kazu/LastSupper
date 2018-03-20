//
//  KSViewController.m
//  LastSupper
//
//  Created by 清水 一征 on 12/10/24.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//


/*
 operation indicatot size 80 x80
 
 */


#import "KSViewController.h"
#import "KSCalc.h"
#import "def.h"
#import <QuartzCore/QuartzCore.h>
#import "KSTableViewController.h"
#import "KSColor.h"
//#import "KSPieChartView.h"

@interface KSViewController ()

@property (nonatomic) float      steps;
@property (nonatomic) float      steps_this;
@property (nonatomic) CGFloat    counter;
@property (nonatomic) CGFloat    counterForThisYear;

//@property (nonatomic, retain) KSPieChartView    *pie;
//@property (nonatomic, retain) KSPieChartView    *pie_second;
//@property (nonatomic, retain) KSPieChartView    *centerPie;
@property (nonatomic) CGFloat      angle_pie;
@property (nonatomic) CGFloat      pause;
@property (nonatomic) BOOL         isPuase;
@property (nonatomic) NSInteger    animationSwitcher;
@property (nonatomic) BOOL         isTouchButton;

- (void)initDiet;
- (void)initialDataSetting;
- (void)initGesture;
- (void)initLabelPosition;
- (void)labelColor;

- (void)load;
- (void)backDate;
- (void)changeRmainAllLabel:(NSTimer *)timer;
- (void)labelAnimation;
//- (void)pieChartInit;
//- (void)pieAnimation;
- (void)animationSwitch;
- (void)callPhotoFunc:(NSString *)src;
- (void)popupView:(UIView *)view src:(NSString *)src;

- (void)displayArrow;

@end

@implementation KSViewController
@synthesize dayFromLastSupper;
@synthesize recordButton;

#pragma mark -
#pragma mark ---------- life cycle ----------
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //indicator
    _indicator        = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.frame  = CGRectMake(0, 0, 50, 50);
    _indicator.center = self.view.center;
    _indicator.color  = [UIColor redColor];
    _indicator.hidden = YES;
    [self.view addSubview:_indicator];
    
    //act indicator for photo and lib
    _actionIndicator.hidden = YES;
    
    //pie chart set
    _animationSwitcher = 3;
    
    //    [self pieChartInit];
    
    //meal image
    _morning_image.userInteractionEnabled = YES;
    _morning_image.tag                    = morningTag;
    _lunch_image.userInteractionEnabled   = YES;
    _lunch_image.tag                      = lunchTag;
    _dinner_image.userInteractionEnabled  = YES;
    _dinner_image.tag                     = dinnerTag;
    
    _ks_img = [[KSImage alloc]init];
    
    KSFaceMarkManager    *face = [KSFaceMarkManager new];
    _normal_state = face.normal_state;
    _good_state   = face.good_state;
    _bad_state    = face.bad_state;
    face          = nil;
    
    //backgroung color
    [self setBackgroundColor];
    
    //notification launch
    [self noticeCenter];
    
    [self initGesture];
    
    [self initLabelPosition];
    [self labelColor];
    
}

- (void)initLabelPosition {
    CGFloat    label_base_x        = 40;
    CGFloat    label_base_y        = 54;
    CGFloat    title_label_width   = 144;
    CGFloat    percent_label_width = 45;
    //    CGFloat    label_width_thisYear = 55;
    CGFloat    label_heigh = 20;
    
    _label_total.frame = CGRectMake(label_base_x,
                                    label_base_y,
                                    title_label_width,
                                    label_heigh);
    
    _percentRemainAll.frame = CGRectMake(label_base_x + title_label_width,
                                         label_base_y,
                                         percent_label_width,
                                         label_heigh);
    
    //    CGRect    screen = [[UIScreen mainScreen] bounds];
    
    _label_year.frame = CGRectMake(label_base_x,
                                   label_base_y + label_heigh,
                                   title_label_width,
                                   label_heigh);
    
    _percentRemainThisYear.frame = CGRectMake(label_base_x + title_label_width,
                                              label_base_y + label_heigh,
                                              percent_label_width,
                                              label_heigh);
    
}

- (void)labelColor {
    
    _label_total.textColor      = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    _percentRemainAll.textColor = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    
    _label_year.textColor            = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    _percentRemainThisYear.textColor = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    
    _today.textColor = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    
    _morning.textColor = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    _lunch.textColor   = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    _dinner.textColor  = RGBA(LABEL_RED, LABEL_GREEN, LABEL_BLUE, 1);
    
}

- (void)initGesture {
    //swipe Left
    UISwipeGestureRecognizer    *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(didSwipeFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.morning_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didSwipeFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.lunch_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didSwipeFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dinner_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    //swip Right
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didSwipeFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.morning_image addGestureRecognizer:swipeGesture];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didSwipeFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.lunch_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didSwipeFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.dinner_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    //swip up
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didUpDownFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.morning_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didUpDownFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.lunch_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didUpDownFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.dinner_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    //swip down
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didUpDownFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.morning_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didUpDownFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.lunch_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(didUpDownFace:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.dinner_image addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
    //tap
    UITapGestureRecognizer    *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFace:)];
    [self.morning_image addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFace:)];
    [self.lunch_image addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFace:)];
    [self.dinner_image addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
}

// 何度も呼ばれる必要があるものを集めている
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //alow img
    _allowImg.hidden = YES;
    
    //    [self pieChartInit];
    
    KSCalc    *calc = [KSCalc new];
    if ( !calc.isInitialLaunchApp ) {
        
        //data load
        [self load];
        
        NSInteger            remain        = [calc remainTimesAll];
        NSNumber             *remainNumber = [NSNumber numberWithInteger:remain];
        NSNumberFormatter    *formatter    = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setGroupingSeparator:@","];
        [formatter setGroupingSize:3];
        
        NSString    *str = [formatter stringForObjectValue:remainNumber];
        
        if ( [calc remainDays] > 0 ) {
            self.dayFromLastSupper.text = [NSString stringWithFormat:@"%@", str];
            
            //percent(remain)
            _percentValue = [calc percentRemainAll];
            NSString    *percent = @"%";
            self.percentRemainAll.text = [NSString stringWithFormat:@"Remain:%4.2f%@", _percentValue, percent];
            
            //percent (this)
            _percentForThisYear = calc.percentRemainThisYear;
            //NSLog(@"_percentForThisYear: %f",_percentForThisYear);
            self.percentRemainThisYear.text = [NSString stringWithFormat:@"Year :%4.2f%@", _percentForThisYear, percent];
            
            //animation start
            [self labelAnimation];
            
        } else { //死亡設定日を過ぎた場合の処理
            self.dayFromLastSupper.text  = [NSString stringWithFormat:@"+%@", str];
            self.percentRemainAll.hidden = YES;
        }
        
        self.recordButton.enabled     = YES;
        self.modal_aniversary.enabled = YES;
        formatter                     = nil;
        
    } else {
        [self alertForSetting];
        [self initialDataSetting];
        
    }
    
    calc = nil;
    
}

- (void)didReceiveMemoryWarning {
    
    NSLog(@"didReceioveMemoryWarning call");
    
    [super didReceiveMemoryWarning];
    if ( [self.view window] == nil ) {
        // viewDidUnloadと同じ処理
        [self setMorning:nil];
        [self setLunch:nil];
        [self setDinner:nil];
        [self setMorning_image:nil];
        [self setLunch_image:nil];
        [self setDinner_image:nil];
        [self setKs_img:nil];
        [self setRecordButton:nil];
        [self setDayFromLastSupper:nil];
        [self setPercentRemainAll:nil];
        [self setPercentRemainThisYear:nil];
        _ks_img = nil;
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
    }
    
}

- (void)viewDidUnload {
    NSLog(@"viewDidUnlod called");
    [self setMorning:nil];
    [self setLunch:nil];
    [self setDinner:nil];
    [self setMorning_image:nil];
    [self setLunch_image:nil];
    [self setDinner_image:nil];
    [self setKs_img:nil];
    [self setRecordButton:nil];
    [self setDayFromLastSupper:nil];
    _ks_img = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super viewDidUnload];
}

- (void)noticeCenter {
    //notifications
    UIApplication    *wiillTerminate = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:wiillTerminate];
    
    UIApplication    *didEnterBack = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:didEnterBack];
    
    UIApplication    *willEnterForground = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:willEnterForground];
    
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    //NSLog(@"applicationWillTerminate call");
    [self save];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    //NSLog(@"applicationDidEnterBackground call");
    [self save];
    
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    //NSLog(@"applicationWillEnterForeground call");
    [self load];
}

#pragma mark -
#pragma mark ---------- swipe & TAP ----------

/*
 左右にスワイプ：Photo
 上下にスワイプ：Lib
 */

#warning _imageOrderがグローバル定数に近いのでなんとかしたい！

- (void)didSwipeFace:(UISwipeGestureRecognizer *)swipe { // call photo
    if ( swipe.view == _morning_image ) {
        
        _imageOrder = Order_morning;
        
    } else if ( swipe.view == _lunch_image ) {
        
        _imageOrder = Order_lunch;
        
    } else if ( swipe.view == _dinner_image ) {
        
        _imageOrder = Order_dinner;
    }
    
    if ( _imageOrder == Order_morning || _imageOrder == Order_lunch || _imageOrder == Order_dinner ) {
        _actionIndicator.hidden = NO;
        _actionIndicator.text   = @"Camera";
        [self popupView:_actionIndicator src:CAMERA];
    }
    
}

- (void)didUpDownFace:(UISwipeGestureRecognizer *)swipe { // call lib
    if ( swipe.view == _morning_image ) {
        //        NSLog(@"updown morning");
        _imageOrder = Order_morning;
        
    } else if ( swipe.view == _lunch_image ) {
        //        NSLog(@"updown lunch");
        _imageOrder = Order_lunch;
        
    } else if ( swipe.view == _dinner_image ) {
        //        NSLog(@"updown dinner");
        _imageOrder = Order_dinner;
    }
    
    if ( _imageOrder == Order_morning || _imageOrder == Order_lunch || _imageOrder == Order_dinner ) {
        _actionIndicator.hidden = NO;
        _actionIndicator.text   = @"Library";
        [self popupView:_actionIndicator src:LIB];
    }
    
}

- (void)didTapFace:(UITapGestureRecognizer *)tap {
    if ( tap.view == _morning_image ) {
        _imageOrder = Order_morning;
        
    } else if ( tap.view == _lunch_image ) {
        _imageOrder = Order_lunch;
        
    } else if ( tap.view == _dinner_image ) {
        _imageOrder = Order_dinner;
        
    }
    
    if ( _imageOrder == Order_morning || _imageOrder == Order_lunch || _imageOrder == Order_dinner ) {
        [self toggleItem:_imageOrder];
    }
}

//フォトライブラリーを呼び出す
- (void)callPhotoFunc:(NSString *)src {
    if ( [src isEqualToString:LIB] ) {
        [self photoLib:LIB];
    } else if ( [src isEqualToString:CAMERA] ) {
        [self photoLib:CAMERA];
    }
    
}

//フォトライブラリー選択後に呼ばれるデリゲート
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // オリジナル画像
    UIImage    *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    // 編集画像
    UIImage    *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    UIImage    *saveImage;
    
    if ( editedImage ) {
        saveImage = editedImage;
    } else {
        saveImage = originalImage;
    }
    
    // UIImageViewに画像を設定
    
    switch ( _imageOrder ) {
        case Order_morning:
            _morning_image.image = [_ks_img cropImageView:saveImage];
            break;
        case Order_lunch:
            _lunch_image.image = [_ks_img cropImageView:saveImage];
            break;
        case Order_dinner:
            _dinner_image.image = [_ks_img cropImageView:saveImage];
            break;
            
        default:
            _imageOrder = Order_MAX;
            break;
    }
    [self save];
    
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
        // カメラから呼ばれた場合は画像をフォトライブラリに保存してViewControllerを閉じる
        UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ( picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // フォトライブラリから呼ばれた場合はPopOverを閉じる（iPad）
        //		[popover dismissPopoverAnimated:YES];
        //		[popover release];
        //		popover = nil;
    }
}

#pragma mark -
#pragma mark ---------- save and load ----------
- (IBAction)save {
    //    NSLog(@"call save method");
    
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
    KSFaceMarkManager    *face = [[KSFaceMarkManager alloc]init];
    newDiet.morning   = [face itemConvertCharactor:_morning_state];
    newDiet.lunch     = [face itemConvertCharactor:_lunch_state];
    newDiet.dinner    = [face itemConvertCharactor:_dinner_state];
    newDiet.bitrh_day = _birthday;
    newDiet.die_day   = _die_day;
    
    _morning_image.image = [_ks_img getThumbImage:_morning_image.image];
    _lunch_image.image   = [_ks_img getThumbImage:_lunch_image.image];
    _dinner_image.image  = [_ks_img getThumbImage:_dinner_image.image];
    
    newDiet.thumbnail_morning = UIImagePNGRepresentation(_morning_image.image);
    newDiet.thumbnail_lunch   = UIImagePNGRepresentation(_lunch_image.image);
    newDiet.thumbnail_dinner  = UIImagePNGRepresentation(_dinner_image.image);
    
    [[KSDietController sharedManager] save];
    
    calc = nil;
    face = nil;
}

- (void)load {
    //表示するDateを選択
    KSDiet     *diet;
    NSArray    *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietNewOld];
    
    KSCalc     *calc = [[KSCalc alloc] init];
    
    if ( ![calc isTodayData] ) { //今日のDataが存在しない場合
        [self initialDataSetting];
        diet      = [array objectAtIndex:FIRST_Object_OF_NSArray];
        _birthday = diet.bitrh_day;
        _die_day  = diet.die_day;
        
        //debug code
        UIImage    *nImage = [UIImage imageNamed:NORMAL_FACE];
        [_morning_image setImage:nImage];
        [_lunch_image setImage:nImage];
        [_dinner_image setImage:nImage];
        
    } else { //すでにDataがある場合
        //日付を選択
        diet       = [array objectAtIndex:FIRST_Object_OF_NSArray];
        _targetDay = diet.today;
        //すでにあるDataを表示
        [self initDiet];
        
    }
    
    NSString    *displayDay = [calc displayDateFormatted:_targetDay];
    _today.text = [NSString stringWithFormat:@"%@", displayDay];
    
    array = nil;
    calc  = nil;
}

- (void)initialDataSetting {
    _targetDay = [NSDate date];
    //diet state setting
    _morning_state = normal_ITEM;
    _lunch_state   = normal_ITEM;
    _dinner_state  = normal_ITEM;
    
}

- (void)initDiet {
    
    NSArray              *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietNewOld];
    
    KSDiet               *diet = [array objectAtIndex:FIRST_Object_OF_NSArray];
    
    KSFaceMarkManager    *face = [[KSFaceMarkManager alloc] init];
    NSString             *stateString;
    _morning_state = [face stringConvertItem:diet.morning];
    stateString    = [face itemConvertString:_morning_state];
    
    UIImage    *init_img_morning;
    
    if ( diet.thumbnail_morning == NULL ) {
        [_morning_image setImage:[UIImage imageNamed:stateString]];
    } else {
        NSData    *mData = diet.thumbnail_morning;
        init_img_morning = [UIImage imageWithData:mData];
        init_img_morning = [_ks_img getThumbImage:init_img_morning];
        [_morning_image setImage:init_img_morning];
    }
    
    _lunch_state = [face stringConvertItem:diet.lunch];
    stateString  = [face itemConvertString:_lunch_state];
    
    UIImage    *init_img_lunch;
    if ( diet.thumbnail_lunch == NULL ) {
        [_lunch_image setImage:[UIImage imageNamed:stateString]];
        
    } else {
        
        NSData    *lData = diet.thumbnail_lunch;
        init_img_lunch = [UIImage imageWithData:lData];
        init_img_lunch = [_ks_img getThumbImage:init_img_lunch];
        [_lunch_image setImage:init_img_lunch];
    }
    
    _dinner_state = [face stringConvertItem:diet.dinner];
    stateString   = [face itemConvertString:_dinner_state];
    
    UIImage    *init_img_dinner;
    if ( diet.thumbnail_dinner == NULL ) {
        [_dinner_image setImage:[UIImage imageNamed:stateString]];
    } else {
        NSData    *dData = diet.thumbnail_dinner;
        init_img_dinner = [UIImage imageWithData:dData];
        init_img_dinner = [_ks_img getThumbImage:init_img_dinner];
        [_dinner_image setImage:init_img_dinner];
    }
    
    _birthday = diet.bitrh_day;
    _die_day  = diet.die_day;
    
    if ( _birthday == NULL ) {
        for ( int i = 1; i < 90; i++ ) {
            diet = [array objectAtIndex:i];
            if ( diet.bitrh_day == NULL ) {
                continue;
            } else {
                _birthday = diet.bitrh_day;
                break;
            }
        }
    }
    
    if ( _die_day == NULL ) {
        for ( int i = 1; i < 90; i++ ) {
            diet = [array objectAtIndex:i];
            if ( diet.die_day == NULL ) {
                continue;
            } else {
                _die_day = diet.die_day;
                break;
            }
        }
    }
    
    array = nil;
    face  = nil;
}

#pragma mark -
#pragma mark Scene
//画面遷移
- (IBAction)modalAndSave {
    //遷移前に新しいDataをセーブしておく
    [self save];
    
    //遷移前に空いているDataを補充する
    [self backDate];
    
    //画面遷移
    UIStoryboard             *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    KSTableViewController    *controller = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)showAniversary {
    NSArray    *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietNewOld];
    
    if ( [array count] > 0 ) { // 初期設定画終わっていれば
        //画面遷移
        UIStoryboard             *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        KSTableViewController    *controller = [storyboard instantiateViewControllerWithIdentifier:@"aniversary"];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark ---------- view animation----------

//- (void)pieChartInit {
//
//    if ( [_pie isDescendantOfView:self.view] ) {
//        [_pie removeFromSuperview];
//    }
//
//    if ( [_pie_second isDescendantOfView:self.view] ) {
//        [_pie_second removeFromSuperview];
//    }
//
//    // parameter for position
//    CGFloat    screen_width = self.view.frame.size.width;
//
//    //main pie chart (all remain and done)
//    float      pie_radius   = screen_width * 0.2;
//    float      pie_diameter = pie_radius * 2.0f;
//
//    // pie chart center
//    float      pieCenter_x = (screen_width * 0.5) - pie_radius;
//    float      pieCenter_y = _today.frame.size.height;
//
//    CGRect     rect = CGRectMake(pieCenter_x, pieCenter_y, pie_diameter, pie_diameter);
//    _pie                 = [[KSPieChartView alloc]initWithFrame:rect];
//
//    NSLog(@"pieCenter_x:%f, y:%f",pieCenter_x,pieCenter_y);
//    //[testing] color changed!
//    _pie.backgroundColor = [UIColor redColor]; //[UIColor clearColor];
//    _pie.radius          = pie_radius;
//
//    KSCalc    *calc = [[KSCalc alloc] init];
//    _pie.DoneValue   = calc.percentDoneAll;
//    _pie.RemainValue = calc.percentRemainAll;
//
//    float    alpha = 0.5;
//    [_pie setColor:DONE r:BASE_R g:BASE_G b:BASE_B a:alpha ];
//    [_pie setColor:DONE_THIS r:255 g:172 b:190 a:alpha ];
//
//    // second pie chart (this year)
//    float     scaleOfSecondCircle = 0.5;
//    float     x_second            = pieCenter_x + (pie_radius - (pie_radius * scaleOfSecondCircle));
//    float     y_second            = pieCenter_y + (pie_radius - (pie_radius * scaleOfSecondCircle));
//
//    CGRect    rect2 = CGRectMake(x_second, y_second, pie_diameter * scaleOfSecondCircle, pie_diameter * scaleOfSecondCircle);
//    _pie_second                 = [[KSPieChartView alloc]initWithFrame:rect2];
//    _pie_second.backgroundColor = [UIColor clearColor];
//    _pie_second.radius          = pie_radius * scaleOfSecondCircle;
//    _pie_second.DoneValue       = calc.percentDoneThisYear;
//    _pie_second.RemainValue     = calc.percentRemainThisYear;
//
//    [_pie_second setColor:DONE r:BASE_R g:BASE_G b:BASE_B a:1 ];
//    [_pie_second setColor:DONE_THIS r:200 g:255 b:239 a:1 ];
//
//    [self.view insertSubview:_pie atIndex:1];
//    [self.view insertSubview:_pie_second atIndex:2];
//
//    //centerCircle for desing
//    float     scaleOfCenterCircle = 0.3;
//    float     x_dash              = pieCenter_x + (pie_radius - (pie_radius * scaleOfCenterCircle));
//    float     y_dash              = pieCenter_y + (pie_radius - (pie_radius * scaleOfCenterCircle));
//    CGRect    cRect               = CGRectMake(x_dash, y_dash, pie_diameter * scaleOfCenterCircle, pie_diameter * scaleOfCenterCircle);
//    _centerPie                 = [[KSPieChartView alloc] initWithFrame:cRect];
//    _centerPie.backgroundColor = [UIColor clearColor];
//    _centerPie.radius          = pie_radius * scaleOfCenterCircle;
//    _centerPie.DoneValue       = 100;
//    _centerPie.DoneThisValue   = 0;
//    _centerPie.RemainValue     = 0;
//    _centerPie.RemainThisValue = 0;
//    [_centerPie setColor:DONE r:BASE_R g:BASE_G b:BASE_B a:1];
//    [self.view insertSubview:_centerPie atIndex:3];
//
//
//    // pie chart のcenterを揃える
//    _pie.center = CGPointMake(100, 100);
//    _pie_second.center = CGPointMake(100, 100);
//    _centerPie.center = CGPointMake(100, 100);
//
//
//    _centerPie = nil;
//
//    //for animation, do not set nil!
//    //_pie = nil;
//    //pie_second = nil;
//
//    _pie.alpha = 0.5f;
//
//    calc = nil;
//}

- (void)changeRmainAllLabel:(NSTimer *)timer {
    
    _counter += _steps;
    
    // _percenet label
    if ( _counter > _percentValue ) {
        _counter = _percentValue;
        [_timer invalidate];
        //        [self performSelector:@selector(pieAnimation) withObject:nil afterDelay:1.5];
    }
    NSString    *percent = @"%";
    self.percentRemainAll.text = [NSString stringWithFormat:@"%4.2f%@", _counter, percent];
    
    _counterForThisYear += _steps_this;
    if ( _counterForThisYear > _percentForThisYear ) {
        _counterForThisYear = _percentForThisYear;
        
    }
    self.percentRemainThisYear.text = [NSString stringWithFormat:@"%4.2f%@", _counterForThisYear, percent];
    
}

- (void)labelAnimation {
    
    _steps      = _percentValue / (ANIMATE_DUTATION + ANIMATE_DELAY) * 0.1;
    _steps_this = _percentForThisYear / (ANIMATE_DUTATION + ANIMATE_DELAY) * 0.1;
    //NSLog(@"step this:%f",_percentForThisYear);
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(changeRmainAllLabel:)
                                            userInfo:nil
                                             repeats:YES];
    
}

//- (void)pieAnimation {
//
//    [NSTimer scheduledTimerWithTimeInterval:0.2f
//                                     target:self
//                                   selector:@selector(pieChartRotate:)
//                                   userInfo:nil
//                                    repeats:YES];
//}

//- (void)pieChartRotate:(NSTimer *)delta {
//
//    float    velocityOfMainPie   = 2.0f;
//    float    velocityOfSecondPie = velocityOfMainPie * 3;
//
//    _pause += 1;
//    if ( _pause > 0 ) {
//        _angle_pie += 360 / 60 * 0.1;
//        CGFloat    angle_pie        = (2 * M_PI * (_angle_pie * velocityOfMainPie) / 360);
//        CGFloat    angle_pie_second = (2 * M_PI * (_angle_pie * velocityOfSecondPie) / 360);
//
//        _pie.transform        = CGAffineTransformMakeRotation(angle_pie);
//        _pie_second.transform = CGAffineTransformMakeRotation(angle_pie_second);
//        _isPuase              = NO;
//
//    }
//
//    if ( _angle_pie > 180 ) {
//        _pause     = -30;
//        _angle_pie = 0;
//        _isPuase   = YES;
//    }
//
//    if ( _isPuase ) {
//        _isPuase = NO;
//
//        [self animationSwitch];
//    }
//
//}

- (void)animationSwitch {
    
    _animationSwitcher++;
    
    switch ( _animationSwitcher ) {
        case 0:
            [self dayFromLastSupperAnimaAway];
            break;
            
        case 1:
            [self dayFromLastSupperAnimaRotate];
            break;
            
        case 2:
            [self dayFromLastSupperAnimaPop];
            break;
            
        case 3:
            [self dayFromLastSupperAnimeUpDown];
            break;
            
        default:
            _animationSwitcher = -1;
            break;
    }
    
}

- (void)dayFromLastSupperAnimeUpDown {
    
    [UIView animateWithDuration:0.8
                     animations:^{
                         dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, -1.0);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.8
                                          animations:^{
                                              dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                     }];
    
}

- (void)dayFromLastSupperAnimaRotate {
    
    [UIView animateWithDuration:0.8
                     animations:^{
                         dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1.0, 1.0);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.8
                                          animations:^{
                                              dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                     }];
    
}

- (void)dayFromLastSupperAnimaAway {
    
    CGFloat    screen_width = self.view.frame.size.width;
    CGRect     rect         = dayFromLastSupper.frame;
    rect.origin.x = dayFromLastSupper.frame.size.width * -1;
    CGPoint    _center_ = CGPointMake(screen_width / 2, dayFromLastSupper.center.y);
    
    //animation parts
    CGFloat    slide_ = rect.size.width * -1;
    
    [UIView animateWithDuration:0.7f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         dayFromLastSupper.frame = CGRectMake(slide_, rect.origin.y, rect.size.width, rect.size.height);
                     } completion:^(BOOL finished) {
                         dayFromLastSupper.frame = CGRectMake(screen_width, rect.origin.y, rect.size.width, rect.size.height);
                         
                         [UIView animateWithDuration:0.5f
                                               delay:0.2f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
                                              dayFromLastSupper.center = _center_;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
}

- (void)dayFromLastSupperAnimaPop {
    dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5f, 0.5f);
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2f, 1.2f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9f, 0.9f);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.2
                                                               animations:^{
                                                                   dayFromLastSupper.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
                                                               }];
                                          }];
                     }];
    
}

- (void)popupView:(UIView *)view src:(NSString *)src {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5f, 0.5f);
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2f, 1.2f);
                     }
     
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9f, 0.9f);
                                          }
                          
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1
                                                                    delay:0.5
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
                                                               }
                                               
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.3
                                                                                         delay:0.1
                                                                                       options:UIViewAnimationOptionCurveLinear
                                                                                    animations:^{
                                                                                        _actionIndicator.hidden = YES;
                                                                                        _actionIndicator.text = @"";
                                                                                    } completion:^(BOOL finished) {
                                                                                        [self callPhotoFunc:src];
                                                                                    }];
                                                                   
                                                               }
                                               
                                               ];
                                              
                                          }
                          
                          ];
                         
                     }
     
     ];
}

#pragma mark -
#pragma mark ---------- others ---------


- (void)toggleItem:(int)tag {
    
    KSFaceMarkManager    *face = [[KSFaceMarkManager alloc] init];
    switch ( tag ) {
        case Order_morning:
            _morning_state++;
            [_morning_image setImage:[face imageSelect:_morning_state]];
            break;
        case Order_lunch:
            _lunch_state++;
            [_lunch_image setImage:[face imageSelect:_lunch_state]];
            break;
        case Order_dinner:
            _dinner_state++;
            [_dinner_image setImage:[face imageSelect:_dinner_state]];
            break;
        default:
            break;
    }
    
    [self save];
    
    face = nil;
}

- (void)backDate {
    
    KSDiet     *backDateDiet;
    KSDiet     *newestDiet;
    NSDate     *previousDate;
    KSCalc     *calc = [[KSCalc alloc] init];
    
    // 最新の日付を得る
    NSArray    *array = [KSDietController sharedManager].sortedDietNewOld;
    if ( [array count] <= 1 ) return;
    
    [_indicator startAnimating];
    // 重い処理はRunLoopの中に記述する
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
    
    newestDiet = [array objectAtIndex:FIRST_Object_OF_NSArray];
    
    //　一日さかのぼってDATAがあるか調べる
    NSDateComponents    *dateComp = [[NSDateComponents alloc] init];
    
    NSInteger           loopMax = [calc blankDays] * -1;
    
    for ( int counter = -1; counter > loopMax; counter-- ) { // 90日前までさかのぼってback dateを計算する
        [dateComp setDay:counter];
        // i 日後のNSDateインスタンスを取得する
        previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:newestDiet.today options:0];
        
        if ( [calc isDataExist:previousDate] ) { // data exist
            //　DATAがあれば終了
            
            break;
            
        } else { //data not exist
            //　DATAがなければDefault値を入れる
            
            backDateDiet           = [[KSDietController sharedManager] insertNewDiet];
            backDateDiet.today     = previousDate;
            backDateDiet.morning   = _normal_state;
            backDateDiet.lunch     = _normal_state;
            backDateDiet.dinner    = _normal_state;
            backDateDiet.bitrh_day = newestDiet.bitrh_day;
            backDateDiet.die_day   = newestDiet.die_day;
            
            [[KSDietController sharedManager] save];
        }
        
    }
    
    [_indicator stopAnimating];
    
    calc     = nil;
    dateComp = nil;
}

- (void)alertForSetting {
    UIAlertView    *alert = [[UIAlertView alloc]
                             initWithTitle:@"初期設定をしてください"
                             message:@""
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
    [alert show];
    alert = nil;
    
    self.recordButton.enabled     = NO;
    self.modal_aniversary.enabled = NO;
    
    [self displayArrow];
    
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

@end
