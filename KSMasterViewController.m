//
//  KSMasterViewController.m
//  LastSupper
//
//  Created by 清水 一征 on 13/05/26.
//  Copyright (c) 2013年 momiji-mac.com. All rights reserved.
//

#import "KSMasterViewController.h"

@interface KSMasterViewController ()

@end

@implementation KSMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self ) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor {

    KSColor            *_color = [KSColor new];
    
    CAGradientLayer    *gradient = [CAGradientLayer layer];
    gradient.frame  = [[UIScreen mainScreen] bounds];
    gradient.colors = [_color gradient_colors_back];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    _color = nil;
}

- (void)photoLib:(NSString *)src {
    UIImagePickerController    *imagePickerController = [[UIImagePickerController alloc]init];
    
    if ( [src isEqualToString:LIB] ) {
        
        //使用可能か確認
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setAllowsEditing:YES];
            [imagePickerController setDelegate:self];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
        }
        
    } else if ( [src isEqualToString:CAMERA] ) {
        
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePickerController setDelegate:self];
            [imagePickerController setAllowsEditing:YES];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            //            [self presentModalViewController:imagePickerController animated:YES];
        }
        
    } else {
        NSLog(@"photo library invalid.");
    }
    
}



#pragma mark -
#pragma mark ---------- screen size ----------
- (BOOL)is568h {
    static BOOL               is568h;
    static dispatch_once_t    onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        is568h = height == 568.f;
    });
    
    return is568h;
}


@end
