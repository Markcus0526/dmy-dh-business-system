//
//  MyOrderTableViewCell.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell
{
    STMyOrderInfo *             mOrderInfo;
    enum EN_ORDERMODE           mOrderMode;
}

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


- (void) initWithData : (id)parent datainfo:(STMyOrderInfo *)datainfo mode:(enum EN_ORDERMODE)mode
{
    mOrderInfo = datainfo;
    mOrderMode = mode;
    
    UIImage * defImage = [UIImage imageNamed:@"ic_stub.png"];
    NSString * imgurl = [NSString stringWithFormat:@"%@%@", [Common baseUrl], datainfo.imgpath];
    [_imgProduct setImageWithURL:[NSURL URLWithUnicodeString:imgurl] placeholderImage:defImage];
    [_lblTitle setText:datainfo.goodname];
    [_lblContent setText:datainfo.gooddesc];
    switch (mode) {
        case ORDERMODE_PAYED:
            if (datainfo.evalstatus == 0) {
                [_lblState setText:STR_WAIT_EVAL];
                [_btnOperate setTitle:STR_GO_EVAL forState:UIControlStateNormal];
                [_btnOperate setHidden:NO];
            } else {
                [_lblState setText:STR_ALEADY_EVAL];
                [_btnOperate setHidden:YES];
            }
            break;
        case ORDERMODE_WAIT:
            if (datainfo.salestatus == 0) {
                [_lblState setText:@""];
                [_btnOperate setTitle:STR_GO_PAY forState:UIControlStateNormal];
                [_btnOperate setHidden:NO];
            } else {
                [_lblState setText:@""];
                [_btnOperate setHidden:YES];
            }
            break;
        case ORDERMODE_RETURN:
            if (datainfo.rejectstatus == 0) {
                [_lblState setText:@""];
                [_btnOperate setTitle:STR_GO_RETURN forState:UIControlStateNormal];
                [_btnOperate setHidden:NO];
            } else {
                [_lblState setText:@""];
                [_btnOperate setHidden:YES];
            }
            break;
        default:
            break;
    }
}

- (IBAction)onTapButton:(id)sender
{
    if (mOrderMode == ORDERMODE_RETURN)
    {
        // show confirm dialog
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退货吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
}


#pragma mark - UIAlertView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // check click confirm
    if (buttonIndex == 1)
    {
        // do reject product
        
    }
}


@end
