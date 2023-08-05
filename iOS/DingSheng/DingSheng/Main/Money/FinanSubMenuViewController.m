//
//  FinanSubMenuViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "FinanSubMenuViewController.h"
#import "ConfirmFinanceViewController.h"

@implementation ServiceTableCell

@end

@interface FinanSubMenuViewController ()
{
    NSMutableArray *                mDataList;
}

@end


#define CELL_ID                     @"cellService"
#define CELL_HEIGHT                 45

@implementation FinanSubMenuViewController

@synthesize mCurSvcMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueFromFinanSubMenuToConfirm"]){
        ConfirmFinanceViewController * destCtrl = (ConfirmFinanceViewController *)segue.destinationViewController;
        destCtrl.mDataInfo = (STServiceInfo *)sender;
        destCtrl.mCurSvcMode = mCurSvcMode;
    }
}



///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    // get recommend goods list
    [self callGetServiceList];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - delegate event of main table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mDataList == nil)
        return 0;
    
    return [mDataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (mDataList == nil)
        return nil;
    
	NSString *cellIdentifier = CELL_ID;
    ServiceTableCell * svcCell = (ServiceTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(svcCell == nil)
    {
        svcCell = [[ServiceTableCell alloc] init];
    }
    //UITableViewCell *cell = nil;
    STServiceInfo * dataInfo = [mDataList objectAtIndex:indexPath.row];
    
    svcCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // initialize cell info
    NSString * imgName = @"";
    if (mDataList.count == 1)
    {
        imgName = @"textback.png";
    }
    else
    {
        if (indexPath.row == 1) {
            imgName = @"account_cell_1.png";
        } else if (indexPath.row == (mDataList.count - 1)) {
            imgName = @"account_cell_2.png";
        } else {
            imgName = @"account_cell_3.png";
        }
    }
    
    UIImage * bg = [UIImage imageNamed:imgName];
    [svcCell.imgBG setImage:bg];
    [svcCell.lblTitle setText:dataInfo.title];
    
	return svcCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([mDataList count] <= indexPath.row)
        return;
    
    STServiceInfo * param = [mDataList objectAtIndex:indexPath.row];
    // show good detail view
    [self performSegueWithIdentifier:@"segueFromFinanSubMenuToConfirm" sender:param];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get good kind list service
 */
- (void) callGetServiceList
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] financeSvcMgr].delegate = self;
    [[[CommManager getCommMgr] financeSvcMgr] GetServiceList:mCurSvcMode];
}

- (void) serviceListResult:(NSInteger)result datalist:(NSMutableArray *)datalist
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set goods data list
        mDataList = datalist;
        [_tblService reloadData];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}


@end
