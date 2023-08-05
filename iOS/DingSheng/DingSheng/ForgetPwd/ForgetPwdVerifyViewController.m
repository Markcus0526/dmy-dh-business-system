//
//  ForgetPwdVerifyViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ForgetPwdVerifyViewController.h"
#import "ForgetPwdResetViewController.h"

@interface ForgetPwdVerifyViewController ()

@end

@implementation ForgetPwdVerifyViewController

@synthesize mPhoneNum;
@synthesize _txtPhoneNum;
@synthesize _txtVerifyKey;

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
    [self initInputControls];
    
    [_txtPhoneNum setText:mPhoneNum];
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
    if ([segue.identifier isEqualToString:@"segueFromForegetPwdChkVerifyToSetMain"]) {
        ForgetPwdResetViewController * destCtrl = (ForgetPwdResetViewController *)segue.destinationViewController;
        destCtrl.mPhoneNum = mPhoneNum;
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation


/**
 * call request verify key service
 */
- (void) callReqVerifyKey : (NSString *)phonenum
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] ReqVerifyKey:phonenum];
}

- (void) reqVerifyKeyResult:(NSInteger)result
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        mPhoneNum = [_txtPhoneNum text];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}


/**
 * call confirm verify key service
 */
- (void) callConfirmVerifyKey : (NSString *)phonenum verifykey:(NSString *)verifykey
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] ConfirmVerifyKey:phonenum verifykey:verifykey];
}

- (void) confirmVerifyKeyResult:(NSInteger)result
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        
        // go to next
        [self performSegueWithIdentifier:@"segueFromForegetPwdChkVerifyToSetMain" sender:self];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - User Interaction (Event)
- (IBAction)onTapReqVerify:(id)sender
{
    // check input text
    if ([NSString isNullOrEmpty:[_txtPhoneNum text]]) {
        [_txtPhoneNum becomeFirstResponder];
        return;
    }
    
    // call require verify key
    [self callReqVerifyKey:[_txtPhoneNum text]];
}

- (IBAction)onTapNext:(id)sender
{
    // check input text
    if ([NSString isNullOrEmpty:[_txtPhoneNum text]]) {
        [_txtPhoneNum becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtVerifyKey text]]) {
        [_txtVerifyKey becomeFirstResponder];
        return;
    }
    
    // call confirm verify key
    [self callConfirmVerifyKey:mPhoneNum verifykey:[_txtVerifyKey text]];
}

@end
