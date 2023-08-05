//
//  ForgetPwdResetViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdResetViewController : SuperViewController <AccountSvcDelegate>

// member variable
@property (nonatomic, retain) NSString *    mPhoneNum;

@property (weak, nonatomic) IBOutlet UITextField *_txtLoginPwd;
@property (weak, nonatomic) IBOutlet UITextField *_txtLoginConfirmPwd;

- (IBAction)onTapConfirm:(id)sender;

@end
