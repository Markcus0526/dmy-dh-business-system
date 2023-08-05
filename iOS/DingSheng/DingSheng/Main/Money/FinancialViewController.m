//
//  FinancialViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "FinancialViewController.h"
#import "FinanSubMenuViewController.h"

@interface FinancialViewController ()
{
    enum EN_SVCMODE             mCurSvcMode;
}

@end

@implementation FinancialViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueFromFinanceToList"]){
        FinanSubMenuViewController * destCtrl = (FinanSubMenuViewController *)segue.destinationViewController;
        destCtrl.mCurSvcMode = mCurSvcMode;
    }
}


- (IBAction)onTapBank:(id)sender
{
    mCurSvcMode = SVCMODE_BANK;
    [self performSegueWithIdentifier:@"segueFromFinanceToList" sender:nil];
}

- (IBAction)onTapCredit:(id)sender
{
    mCurSvcMode = SVCMODE_CREDIT;
    [self performSegueWithIdentifier:@"segueFromFinanceToList" sender:nil];
}

- (IBAction)onTapInsur:(id)sender
{
    mCurSvcMode = SVCMODE_INSURANCE;
    [self performSegueWithIdentifier:@"segueFromFinanceToList" sender:nil];
}

- (IBAction)onTapProperty:(id)sender
{
    mCurSvcMode = SVCMODE_PROPERTY;
    [self performSegueWithIdentifier:@"segueFromFinanceToList" sender:nil];
}

- (IBAction)onTapSmall:(id)sender
{
    mCurSvcMode = SVCMODE_SMALLPROD;
    [self performSegueWithIdentifier:@"segueFromFinanceToList" sender:nil];
}
@end
