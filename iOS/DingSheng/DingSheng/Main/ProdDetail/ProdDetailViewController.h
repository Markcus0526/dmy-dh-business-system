//
//  ProdDetailViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface ProdDetailViewController : SuperViewController <GoodsSvcDelegate, SGFocusImageFrameDelegate>

@property (nonatomic, readwrite) long       mProdId;


@property (weak, nonatomic) IBOutlet UIView *vwImgContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIWebView *webGoodDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblShopAddr;
@property (weak, nonatomic) IBOutlet UILabel *lblShopPhone;
@property (weak, nonatomic) IBOutlet UITextView *txtBuyDesc;


- (IBAction)onTapPhone:(id)sender;


@end
