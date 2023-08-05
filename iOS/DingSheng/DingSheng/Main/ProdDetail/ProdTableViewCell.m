//
//  ProdTableViewCell.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/7/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ProdTableViewCell.h"

@implementation ProdTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
