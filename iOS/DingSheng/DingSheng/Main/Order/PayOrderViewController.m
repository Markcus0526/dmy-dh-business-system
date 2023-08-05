//
//  PayOrderViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "PayOrderViewController.h"

@interface PayOrderViewController ()

@end

@implementation PayOrderViewController

@synthesize mOrderInfo;
@synthesize mCount;
@synthesize mTotalPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) initControl
{
    // set data to ui
    [_lblName setText:mOrderInfo.goodname];
    [_lblCount setText:[NSString stringWithFormat:@"%d", mCount]];
    [_lblPrice setText:[NSString stringWithFormat:@"%d元", mOrderInfo.price]];
    [_lblTotalPrice setText:[NSString stringWithFormat:@"%d元", mTotalPrice]];
}

@end
