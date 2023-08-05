//
//  ViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/27/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "LoginViewController.h"
#import "Config.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize _chkSavePwd;
@synthesize _txtPassword;
@synthesize _txtUserName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    // init input controls
    [self initInputControls];
    
    // check user config info
    if (![NSString isNullOrEmpty:[Config loginName]]) {
        [_txtUserName setText:[Config loginName]];
        [_txtPassword setText:[Config loginPassword]];
        [_chkSavePwd setSelected:YES];
    }
}

/**
 * Save login username & password
 */
- (void) SaveLoginOption
{
    [Config setLoginName:[_txtUserName text]];
    [Config setLoginPassword:[_txtPassword text]];
}

/**
 * Go to main view controller
 */
- (void) gotoNext
{
    if ([_chkSavePwd isSelected])
    {
        [self SaveLoginOption];
    }
    
    // go to main view controller
    [self performSegueWithIdentifier:@"segueFromLoginToMain" sender:self];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call login user service
 */
- (void) callLogin : (NSString *)username password:(NSString *)password
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] LoginUser:username password:password macaddr:[GlobalFunc getDeviceMacAddress]];
}

- (void) loginUserResult:(NSInteger)result userid:(long)userid baseUrl:(NSString *)baseUrl
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        
        // set user info
        [Common setUserId:userid];
        [Common setBaseUrl:baseUrl];
        
        [self gotoNext];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - User Interaction (Event)

- (IBAction)onTapLogin:(id)sender
{
    // check input value
    if ([NSString isNullOrEmpty:[_txtUserName text]]) {
        [_txtUserName becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtPassword text]]) {
        [_txtPassword becomeFirstResponder];
        return;
    }
    
    // call service
    [self callLogin:[_txtUserName text] password:[_txtPassword text]];
}

- (IBAction)onTapSavePwd:(id)sender
{
    if ([_chkSavePwd isSelected]) {
        [_chkSavePwd setSelected:NO];
    } else {
        [_chkSavePwd setSelected:YES];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Prepare For Seque
//
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ( [segue.identifier isEqualToString:@"segueFromAvatarEditToAvatarConfirm"]){
//        [segue.destinationViewController setImageAvatar:self.selectedImage];
//    }
//}


@end
