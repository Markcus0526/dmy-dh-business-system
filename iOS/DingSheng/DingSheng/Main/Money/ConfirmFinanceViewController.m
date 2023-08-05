//
//  ConfirmFinanceViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ConfirmFinanceViewController.h"
#import "SetFinanceTableViewController.h"

@interface ConfirmFinanceViewController ()

@end

@implementation ConfirmFinanceViewController

@synthesize mDataInfo;
@synthesize mCurSvcMode;

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
    
    [self initControls];
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
    if ([segue.identifier isEqualToString:@"segueFromConfrimFinanceToSet"]){
        SetFinanceTableViewController * destCtrl = (SetFinanceTableViewController *)segue.destinationViewController;
        destCtrl.mCardId = mDataInfo.uid;
        destCtrl.mCurSvcMode = mCurSvcMode;
    }

}



///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

- (void) initControls
{
    self.navigationItem.title = mDataInfo.title;
    [_txtContent setText:mDataInfo.content];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - UI Event 

- (IBAction)onTapConfirm:(id)sender
{
    // go to upload controller
    [self performSegueWithIdentifier:@"segueFromConfrimFinanceToSet" sender:nil];
}

- (IBAction)onSelectAgree:(id)sender
{
    if ([_chkMark isSelected]) {
        [_chkMark setSelected:NO];
        [_btnConfirm setEnabled:NO];
    } else {
        [_chkMark setSelected:YES];
        [_btnConfirm setEnabled:YES];
    }
}

@end
