//
//  PubOrderViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextStepperField.h"

@interface PubOrderViewController : SuperViewController <GoodsSvcDelegate, TextStepperDelegate>

// public member variable
@property (nonatomic, readwrite) long       mProdId;

// member ui controls
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet TextStepperField *ctrlCntStepper;
@property (weak, nonatomic) IBOutlet UIButton *chkUseAccum;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAccum;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblUsedAccum;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *chkReject;
@property (weak, nonatomic) IBOutlet UIView *vwAccumView1;
@property (weak, nonatomic) IBOutlet UIView *vwAccumView2;

// ui event
- (IBAction)onSelectUseAccum:(id)sender;
- (IBAction)onSelectReject:(id)sender;


@end
