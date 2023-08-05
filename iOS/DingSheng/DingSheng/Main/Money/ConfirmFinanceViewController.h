//
//  ConfirmFinanceViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmFinanceViewController : SuperViewController

// Member Variable
@property (nonatomic, readwrite) enum EN_SVCMODE            mCurSvcMode;
@property (nonatomic, retain) STServiceInfo *               mDataInfo;

// UI Controls
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UIButton *chkMark;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

// UI Event
- (IBAction)onTapConfirm:(id)sender;
- (IBAction)onSelectAgree:(id)sender;

@end
