//
//  ForgetPwdInputPhoneViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdInputPhoneViewController : SuperViewController <AccountSvcDelegate>

@property (weak, nonatomic) IBOutlet UITextField *_txtPhoneNum;

- (IBAction)onRewind:(id)sender;
- (IBAction)onTapReqVerify:(id)sender;

@end
