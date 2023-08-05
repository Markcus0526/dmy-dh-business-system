//
//  PubOrderViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "PubOrderViewController.h"
#import "PayOrderViewController.h"

@interface PubOrderViewController ()
{
    STGoodOrderInfo *           mDataInfo;
}

@end

@implementation PubOrderViewController

@synthesize mProdId;

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
    if ([segue.identifier isEqualToString:@"segueFromPubOrderToConfrim"]){
        PayOrderViewController * destCtrl = (PayOrderViewController *)segue.destinationViewController;
        destCtrl.mOrderInfo = mDataInfo;
        destCtrl.mTotalPrice = [self calcTotalPrice];
        destCtrl.mCount = (int)[_ctrlCntStepper Current];
    }
}

////////////////////////////////////////////////////////////////////////////
#pragma mark - Initilaize
- (void) initControls
{
    // init text stepper
    _ctrlCntStepper.Current = 1;
    _ctrlCntStepper.Step = 1;
    _ctrlCntStepper.Minimum = 1;
    _ctrlCntStepper.Maximum = 100;
    _ctrlCntStepper.IsEditableTextField = FALSE;
    _ctrlCntStepper.delegate = self;
    
    // get good order info
    [self callGetGoodOrderInfo];
}

- (void) updateUI
{
    _ctrlCntStepper.Maximum = mDataInfo.count;
    [_lblName setText:mDataInfo.goodname];
    [_lblPrice setText:[NSString stringWithFormat:@"%d", mDataInfo.price]];
    [_lblUserAccum setText:[NSString stringWithFormat:@"%d", mDataInfo.usermark]];
    [_lblTotalPrice setText:[NSString stringWithFormat:@"%d元", mDataInfo.price]];
    [_lblUsedAccum setText:@"0分"];
    [_lblPhone setText:mDataInfo.userphone];

    // check using mark
    if (mDataInfo.usingmark == 0) {
        [_vwAccumView1 setHidden:YES];
        [_vwAccumView2 setHidden:YES];
    }
}

- (int) calcTotalPrice
{
    int totalPrice = 0;
    
    totalPrice = (int)[_ctrlCntStepper Current] * mDataInfo.price;
    // minus used accum
    if ([_chkUseAccum isSelected]) {
        int accum = (mDataInfo.usermark > mDataInfo.marklimit) ? mDataInfo.marklimit : mDataInfo.usermark;
        totalPrice -= accum / 100;
    }
    
    return totalPrice;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Text Stepper Delegate
- (void) didTextStepperChanged:(TextStepperField *)textStepper
{
    if (textStepper == _ctrlCntStepper) {
        // change total price
        [_lblTotalPrice setText:[NSString stringWithFormat:@"%d元", [self calcTotalPrice]]];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get good order info service
 */
- (void) callGetGoodOrderInfo
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] goodsSvcMgr].delegate = self;
    [[[CommManager getCommMgr] goodsSvcMgr] GetGoodOrderInfo:[Common userId] goodid:mProdId];
}

- (void) goodOrderInfoResult:(NSInteger)result datainfo:(STGoodOrderInfo *)datainfo
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set good order data info
        mDataInfo = datainfo;
        [self updateUI];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
        [self performSelector:@selector(onTapBack:) withObject:nil afterDelay:DEF_DELAY];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - UI Event

- (IBAction)onSelectUseAccum:(id)sender
{
    // check allow flag
    if (mDataInfo.usingmark == 0) {
        return;
    }
    
    if ([_chkUseAccum isSelected]) {
        [_chkUseAccum setSelected:NO];
        // set value
        [_lblUsedAccum setText:@"0分"];
    } else {
        [_chkUseAccum setSelected:YES];
        // set value
        int accum = (mDataInfo.usermark > mDataInfo.marklimit) ? mDataInfo.marklimit : mDataInfo.usermark;
        [_lblUsedAccum setText:[NSString stringWithFormat:@"%d分", accum]];
    }
    
    [_lblTotalPrice setText:[NSString stringWithFormat:@"%d元", [self calcTotalPrice]]];
}

- (IBAction)onSelectReject:(id)sender
{
    // check allow flag
    if (mDataInfo.isreject == 0) {
        return;
    }
    
    if ([_chkReject isSelected]) {
        [_chkReject setSelected:NO];
    } else {
        [_chkReject setSelected:YES];
    }
}


@end
