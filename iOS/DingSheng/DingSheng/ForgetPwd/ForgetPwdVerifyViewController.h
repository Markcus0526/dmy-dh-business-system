//
//  ForgetPwdVerifyViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdVerifyViewController : SuperViewController <AccountSvcDelegate>

// member variable
@property (nonatomic, retain) NSString *    mPhoneNum;

// ui controls
@property (weak, nonatomic) IBOutlet UITextField *_txtPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *_txtVerifyKey;

// user event
- (IBAction)onTapReqVerify:(id)sender;
- (IBAction)onTapNext:(id)sender;

@end
