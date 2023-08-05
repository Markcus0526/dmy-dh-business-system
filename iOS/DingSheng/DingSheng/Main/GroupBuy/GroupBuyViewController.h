//
//  GroupBuyViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/28/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblNotice;

@end

@interface GroupBuyViewController : SuperViewController <GoodsSvcDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *kindScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tblGoodList;

@end
