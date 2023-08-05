//
//  SetFinanceTableViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetFinanceTableViewController : SuperTableViewController <FinanceSvcDelegate>

// Member Variable
@property (nonatomic, readwrite) enum EN_SVCMODE            mCurSvcMode;
@property (nonatomic, readwrite) long                       mCardId;

// UI Controls
@property (weak, nonatomic) IBOutlet UITextField *txtCardName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAuthCode;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextView *txtNotice;

// UI Event
- (IBAction)onTapConfirm:(id)sender;

@end
