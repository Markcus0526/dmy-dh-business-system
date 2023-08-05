//
//  MyOrdersViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrdersViewController : SuperViewController <UITableViewDataSource, UITableViewDelegate, AccountSvcDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnType1;
@property (weak, nonatomic) IBOutlet UIButton *btnType2;
@property (weak, nonatomic) IBOutlet UIButton *btnType3;


- (IBAction)onTapOrderType1:(id)sender;
- (IBAction)onTapOrderType2:(id)sender;
- (IBAction)onTapOrderType3:(id)sender;

@end
