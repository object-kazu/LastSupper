//
//  KSEditViewController.m
//  LastSupper
//
//  Created by 清水 一征 on 13/03/02.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KSColor.h"

@interface KSEditViewController ()
- (void)dietDataSet;
- (void)save_edit;
- (void)back;

@end

@implementation KSEditViewController

static KSEditViewController    *sharedInstance = nil;
+ (KSEditViewController *)sharedManager {
    if ( !sharedInstance ) {
        sharedInstance = [[KSEditViewController alloc] init];
    }
    
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _morning_image.userInteractionEnabled = YES;
    _morning_image.tag                    = morningTag;
    _lunch_image.userInteractionEnabled   = YES;
    _lunch_image.tag                      = lunchTag;
    _dinner_image.userInteractionEnabled  = YES;
    _dinner_image.tag                     = dinnerTag;
    
    _editingDate.textColor = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    _morning.textColor     = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    _lunch.textColor       = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    _dinner.textColor      = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    
    [super setBackgroundColor];
    //load data
    [self dietDataSet];
    
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

#pragma mark -
#pragma mark ---------- load ----------
- (void)dietDataSet {
    
    if ( _selectedIndexPath == nil ) return;
    
    NSArray     *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietOldNew];
    _editDiet = [array objectAtIndex:_selectedIndexPath.row];
    KSImage     *ks_img = [[KSImage alloc] init];
    KSCalc      *calc   = [[KSCalc alloc] init];
    
    NSString    *displayDay = [calc displayDateFormatted:_editDiet.today];
    _editingDate.text = displayDay;
    
    if ( _editDiet.thumbnail_morning ) {
        
        NSData     *mData       = _editDiet.thumbnail_morning;
        UIImage    *morning_img = [UIImage imageWithData:mData];
        morning_img = [ks_img getThumbImage:morning_img];
        [_morning_image setImage:morning_img];
        
    } else {
        UIImage    *img = [UIImage imageNamed:[calc stringConvertImgFileName:_editDiet.morning]];
        [_morning_image setImage:img];
        
    }
    
    if ( _editDiet.thumbnail_lunch ) {
        NSData     *lData     = _editDiet.thumbnail_lunch;
        UIImage    *lunch_img = [UIImage imageWithData:lData];
        lunch_img = [ks_img getThumbImage:lunch_img];
        [_lunch_image setImage:lunch_img];
        
    } else {
        UIImage    *img = [UIImage imageNamed:[calc stringConvertImgFileName:_editDiet.lunch]];
        [_lunch_image setImage:img];
        
    }
    
    if ( _editDiet.thumbnail_dinner ) {
        NSData     *dData      = _editDiet.thumbnail_dinner;
        UIImage    *dinner_img = [UIImage imageWithData:dData];
        dinner_img = [ks_img getThumbImage:dinner_img];
        [_dinner_image setImage:dinner_img];
        
    } else {
        UIImage    *img = [UIImage imageNamed:[calc stringConvertImgFileName:_editDiet.dinner]];
        [_dinner_image setImage:img];
        
    }
    
    ks_img = nil;
    calc   = nil;
    array  = nil;
}

- (void)back {
    //画面遷移
    if ( ![self isBeingDismissed] ) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
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
        [self photoLib:CAMERA];
        
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
        [self photoLib:LIB];
        
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
    KSImage    *img = [[KSImage alloc]init];
    switch ( _imageOrder ) {
        case Order_morning:
            _morning_image.image = [img cropImageView:saveImage];
            break;
        case Order_lunch:
            _lunch_image.image = [img cropImageView:saveImage];
            break;
        case Order_dinner:
            _dinner_image.image = [img cropImageView:saveImage];
            break;
            
        default:
            break;
    }
    
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
    //[self save_edit];
}

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
            NSLog(@"touched at not-buttun");
            
            break;
    }
    
    face = nil;
    
}

- (void)save_edit {
    
    KSImage              *img  = [[KSImage alloc] init];
   
    _morning_image.image = [img getThumbImage:_morning_image.image];
    _lunch_image.image   = [img getThumbImage:_lunch_image.image];
    _dinner_image.image  = [img getThumbImage:_dinner_image.image];
    
    _editDiet.thumbnail_morning = UIImagePNGRepresentation(_morning_image.image);
    _editDiet.thumbnail_lunch   = UIImagePNGRepresentation(_lunch_image.image);
    _editDiet.thumbnail_dinner  = UIImagePNGRepresentation(_dinner_image.image);
    
    [[KSDietController sharedManager] save];
    
    img  = nil;
    
}

- (void)editingDone {
    
    //save
    [self save_edit];
    
    //終了処理
    _editingDate   = nil;
    _editing_done  = nil;
    _morning_image = nil;
    _lunch_image   = nil;
    _dinner_image  = nil;
    _birthday      = nil;
    _die_day       = nil;
    _mData         = nil;
    _lData         = nil;
    _dData         = nil;
    
    [self back];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
