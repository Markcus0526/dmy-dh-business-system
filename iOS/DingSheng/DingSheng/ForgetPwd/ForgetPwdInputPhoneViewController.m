//
//  ForgetPwdInputPhoneViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ForgetPwdInputPhoneViewController.h"
#import "ForgetPwdVerifyViewController.h"

@interface ForgetPwdInputPhoneViewController ()

@end

@implementation ForgetPwdInputPhoneViewController

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueFromForgetPwdVerifyToChkVerify"]) {
        ForgetPwdVerifyViewController * destCtrl = (ForgetPwdVerifyViewController *)segue.destinationViewController;
        destCtrl.mPhoneNum = [self._txtPhoneNum text];
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
        
        // go to next
        [self performSegueWithIdentifier:@"segueFromForgetPwdVerifyToChkVerify" sender:self];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - User Interaction (Event)
- (IBAction)onRewind:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapReqVerify:(id)sender
{
    // check input text
    if ([NSString isNullOrEmpty:[self._txtPhoneNum text]]) {
        [self._txtPhoneNum becomeFirstResponder];
        return;
    }
    
    // call require verify key
    [self callReqVerifyKey:[self._txtPhoneNum text]];
}


@end
