//
//  MyOrderTableViewCell.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell <UIAlertViewDelegate>

// Member UI Controls
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIButton *btnOperate;

- (void) initWithData : (id)parent datainfo:(STMyOrderInfo *)datainfo mode:(enum EN_ORDERMODE)mode;

// UI Event
- (IBAction)onTapButton:(id)sender;

@end
