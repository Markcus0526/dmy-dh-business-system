//
//  FinanSubMenuViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;

@end


@interface FinanSubMenuViewController : SuperViewController <FinanceSvcDelegate, UITableViewDataSource, UITableViewDelegate>

// Member Variable
@property (nonatomic, readwrite) long                       mCardId;
@property (nonatomic, readwrite) enum EN_SVCMODE            mCurSvcMode;

// Member UI Control
@property (weak, nonatomic) IBOutlet UITableView *tblService;

@end
