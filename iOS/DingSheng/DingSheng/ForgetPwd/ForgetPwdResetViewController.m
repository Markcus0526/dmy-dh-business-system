//
//  ForgetPwdResetViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ForgetPwdResetViewController.h"

@interface ForgetPwdResetViewController ()

@end

@implementation ForgetPwdResetViewController

@synthesize _txtLoginConfirmPwd;
@synthesize _txtLoginPwd;
@synthesize mPhoneNum;

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


///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call reset password service
 */
- (void) callResetPwd : (NSString *)password phonenum:(NSString *)phonenum
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] ResetPassword:0 phonenum:phonenum password:password];
}

- (void) resetPasswordResult:(NSInteger)result
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismissWithSuccess:MSG_SUCCESS afterDelay:DEF_DELAY];
        [self performSelector:@selector(onRewind:) withObject:nil afterDelay:DEF_DELAY];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}


- (void)onRewind:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - User Interaction (Event)
- (IBAction)onTapConfirm:(id)sender {
    
    if ([NSString isNullOrEmpty:[_txtLoginPwd text]]) {
        [_txtLoginPwd becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtLoginConfirmPwd text]]) {
        [_txtLoginConfirmPwd becomeFirstResponder];
        return;
    }
    if (![[_txtLoginPwd text] isEqualToString:[_txtLoginConfirmPwd text]]) {
        [self.view makeToast:MSG_CORRECT_SECPWD duration:DEF_DELAY position:@"center"];
        return;
    }
    
    // call reset user
    [self callResetPwd:[_txtLoginPwd text] phonenum:mPhoneNum];
}

@end
