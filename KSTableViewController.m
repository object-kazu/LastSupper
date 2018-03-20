//
//  KSTableViewController.m
//  LastSupper
//
//  Created by 清水 一征 on 12/10/25.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#import "KSTableViewController.h"
#import "KSDietController.h"
#import "KSCalc.h"
#import "KSImage.h"

@interface KSTableViewController ()

- (void)gotoEditView;

@end

@implementation KSTableViewController

#pragma mark -
#pragma mark ---------- life cycle ----------
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if ( self ) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dateCalc         = [[KSCalc alloc] init];
    _backbutton.style = UIBarButtonItemStyleBordered;
    
}

//tableの一番下を表示する
- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    
    int            section    = [self.tableView numberOfSections] - 1;
    int            row        = [self.tableView numberOfRowsInSection:section] - 1;
    NSIndexPath    *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    //swip
    UISwipeGestureRecognizer    *swipeGesture =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self action:@selector(didSwipeCell:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeGesture];
    swipeGesture = nil;
    
}

- (void)didReceiveMemoryWarning {
    
    NSLog(@"didReceioveMemoryWarning call");
    
    [super didReceiveMemoryWarning];
    if ( [self.view window] == nil ) {
        _dateCalc      = nil;
        _year          = nil;
        _month_day     = nil;
        _morning_img   = nil;
        _lunch_img     = nil;
        _dinner_img    = nil;
        _morning_score = nil;
        _lunch_score   = nil;
        _dinner_score  = nil;
        _dietResults   = nil;
        
    }
}

- (void)viewDidUnload {
    
    _dateCalc = nil;
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)back {
    //画面遷移
    if ( ![self isBeingDismissed] ) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark -
#pragma mark ---------- swipe ----------

- (void)didSwipeCell:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    if ( [[self.tableView indexPathsForVisibleRows] count] == 0 ) {
        return;
    }
    
    CGPoint        loc        = [swipeRecognizer locationInView:self.tableView];
    NSIndexPath    *indexPath = [self.tableView indexPathForRowAtPoint:loc];
    
    if ( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        _selectedIndexPath = indexPath;
        [self gotoEditView];

    }
    
}

#pragma mark -
#pragma mark ---------- edit view ----------

- (void)gotoEditView {
    // index が設定されているか確認
    if ( _selectedIndexPath == Nil ) {
        return;
    }
    
    //画面遷移
    UIStoryboard            *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    KSEditViewController    *controller = [storyboard instantiateViewControllerWithIdentifier:@"edit"];
    
    //indexPath を渡してEditViewでデーターを展開すること！
    controller.selectedIndexPath = _selectedIndexPath;
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark ---------- Table delegate ----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger    count = [[KSDietController sharedManager].sortedDietOldNew count];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KSDietCell    *cell;
    cell = (KSDietCell *)[tableView dequeueReusableCellWithIdentifier:@"KSDietCell"];
    if ( !cell ) {
        cell = [[KSDietCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KSDietCell"];
    }
    NSArray             *array = [[NSArray alloc] initWithArray:[KSDietController sharedManager].sortedDietOldNew];
    
    KSDiet              *diet = [array objectAtIndex:indexPath.row];
    
    NSDate              *date_ =  diet.today;
    
    NSDateComponents    *dateComps = [_dateCalc separateDateComponets:date_];
    
    cell.yearLabel.text = [NSString stringWithFormat:@"%d", dateComps.year];
    cell.yearLabel.textColor = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    cell.monthAndDayLabel.text = [NSString stringWithFormat:@"%2d / %2d", dateComps.month, dateComps.day];
    cell.monthAndDayLabel.textColor = RGB(LABEL_RED, LABEL_GREEN, LABEL_BLUE);
    
    
    
    KSCalc     *calc   = [[KSCalc alloc] init];
    KSImage    *ks_img = [[KSImage alloc] init];
    
    if ( diet.thumbnail_morning ) {
        
        NSData     *mData       = diet.thumbnail_morning;
        UIImage    *morning_img = [UIImage imageWithData:mData];
        morning_img = [ks_img getThumbImage:morning_img];
        [cell.morningImage setImage:morning_img];
        
    } else {
        
        [cell.morningImage setImage:[UIImage imageNamed:[calc stringConvertImgFileName:diet.morning]]];
        
    }
    
    if ( diet.thumbnail_lunch ) {
        NSData     *lData     = diet.thumbnail_lunch;
        UIImage    *lunch_img = [UIImage imageWithData:lData];
        lunch_img = [ks_img getThumbImage:lunch_img];
        [cell.lunchImage setImage:lunch_img];
        
    } else {
        
        [cell.lunchImage setImage:[UIImage imageNamed:[calc stringConvertImgFileName:diet.lunch]]];
    }
    
    if ( diet.thumbnail_dinner ) {
        NSData     *dData      = diet.thumbnail_dinner;
        UIImage    *dinner_img = [UIImage imageWithData:dData];
        dinner_img = [ks_img getThumbImage:dinner_img];
        [cell.dinnerImage setImage:dinner_img];
    } else {
        
        [cell.dinnerImage setImage:[UIImage imageNamed:[calc stringConvertImgFileName:diet.dinner]]];
    }
    
    // display only
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    

    array     = nil;
    dateComps = nil;
    calc      = nil;
    
    return cell;
}

//cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_Height;
}

@end
