//
//  ViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/27/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : SuperViewController <AccountSvcDelegate>

// ui controls
@property (weak, nonatomic) IBOutlet UITextField *_txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *_txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *_chkSavePwd;

// event
- (IBAction)onTapLogin:(id)sender;
- (IBAction)onTapSavePwd:(id)sender;

@end
