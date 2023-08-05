//
//  RegMainViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "RegMainViewController.h"

@interface RegMainViewController ()

@end

@implementation RegMainViewController

@synthesize _txtLoginConfirmPwd;
@synthesize _txtLoginName;
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
 * call confirm verify key service
 */
- (void) callRegisterUser : (NSString *)username password:(NSString *)password phonenum:(NSString *)phonenum
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] RegisterUser:username password:password phonenum:phonenum macaddr:[GlobalFunc getDeviceMacAddress]];
}

- (void) registerUserResult:(NSInteger)result userid:(long)userid baseUrl:(NSString *)baseUrl
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        
        [Common setUserId:userid];
        [Common setBaseUrl:baseUrl];
        
        // go to main view controller
        [self performSegueWithIdentifier:@"segueFromRegisterToMain" sender:self];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - User Interaction (Event)
- (IBAction)onTapConfirm:(id)sender {
    
    if ([NSString isNullOrEmpty:[_txtLoginName text]]) {
        [_txtLoginName becomeFirstResponder];
        return;
    }
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
    
    // call register user
    [self callRegisterUser:[_txtLoginName text] password:[_txtLoginPwd text] phonenum:mPhoneNum];
}
@end
