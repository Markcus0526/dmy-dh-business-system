//
//  RegInputPhoneViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegInputPhoneViewController : SuperViewController <AccountSvcDelegate>

@property (weak, nonatomic) IBOutlet UITextField *_txtPhoneNum;

- (IBAction)onRewind:(id)sender;
- (IBAction)onTapReqVerify:(id)sender;

@end
