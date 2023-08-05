//
//  ProdSearchViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/7/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdSearchViewController : SuperViewController <GoodsSvcDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite) int        mMode;
@property (nonatomic, readwrite) long       mKindId;


@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblGoodList;


- (IBAction)onTapSearch:(id)sender;

@end
