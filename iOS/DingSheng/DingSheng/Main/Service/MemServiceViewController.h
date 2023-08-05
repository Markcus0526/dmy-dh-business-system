//
//  MemServiceViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDatePickerViewController.h"

@interface MemServiceViewController : SuperTableViewController <AccountSvcDelegate, CustomDatePickerDelegate>
{
    STUserInfo *            mUserInfo;
    NSString *              mUserImgData;
}


@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;
@property (weak, nonatomic) IBOutlet UITextField *txtRealName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrders;
@property (weak, nonatomic) IBOutlet UILabel *lblAccum;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;


- (IBAction)onTapImage:(id)sender;
- (IBAction)onTapBirthday:(id)sender;
- (IBAction)onTapConfirm:(id)sender;

@end
