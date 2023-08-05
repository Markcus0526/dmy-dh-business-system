//
//  PayOrderViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderViewController : SuperViewController

@property (nonatomic, retain) STGoodOrderInfo *         mOrderInfo;
@property (nonatomic, readwrite) int                    mCount;
@property (nonatomic, readwrite) int                    mTotalPrice;


@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;


@end
