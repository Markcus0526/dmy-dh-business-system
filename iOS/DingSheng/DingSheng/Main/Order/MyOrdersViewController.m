//
//  MyOrdersViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/3/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "MyOrderTableViewCell.h"
#import "MJRefresh.h"

@interface MyOrdersViewController ()
{
    enum EN_ORDERMODE               mMode;
    NSMutableArray *                mOrderList;
    int                             mCurPageNum;
}

@end


#define ORDERCELL_HEIGHT                85
#define ORDERCELL_ID                    @"cellMyOrder"

@implementation MyOrdersViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    [self setupTableRefresh];
    
    mCurPageNum = 0;
    mMode = ORDERMODE_PAYED;
    [self callGetOrderList:mMode pageno:mCurPageNum];
}


- (void)setupTableRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tblOrder addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tblOrder.footerPullToRefreshText = MSG_TBLFOOTER_PULL;
    _tblOrder.footerReleaseToRefreshText = MSG_TBLFOOTER_RELEASE;
    _tblOrder.footerRefreshingText = MSG_TBLFOOTER_REFRESHING;
}


/**
 * update goods tableview
 */
- (void) updateUI
{
    [_tblOrder reloadData];
    
    // stop refreshing
    [_tblOrder footerEndRefreshing];
}


#pragma mark - Pull refresh event

- (void)footerRereshing
{
    mCurPageNum++;
    [self callGetOrderList:mMode pageno:mCurPageNum];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - delegate event of main table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mOrderList == nil)
        return 0;
    
    return [mOrderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return ORDERCELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (mOrderList == nil)
        return nil;
    
	static NSString *cellIdentifier = ORDERCELL_ID;
    MyOrderTableViewCell * orderCell = (MyOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(orderCell == nil)
    {
        orderCell = [[MyOrderTableViewCell alloc] init];
    }
    //UITableViewCell *cell = nil;
    STMyOrderInfo * dataInfo = [mOrderList objectAtIndex:indexPath.row];
    
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    // initialize cell info
    [orderCell initWithData:self datainfo:dataInfo mode:mMode];
    
	return orderCell;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get good kind list service
 */
- (void) callGetOrderList : (enum EN_ORDERMODE)mode pageno:(int)pageno
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] GetMyOrderList:[Common userId] mode:mode pageno:pageno];
}

- (void) getMyOrderListResult:(NSInteger)result datalist:(NSMutableArray *)datalist
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        if([datalist count] > 0) {
            if (mOrderList == nil) {
                mOrderList = datalist;
            } else {
                [mOrderList addObjectsFromArray:datalist];
            }
        }
        [self updateUI];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - UI Event

- (IBAction)onTapOrderType1:(id)sender
{
    mCurPageNum = 0;
    [mOrderList removeAllObjects];
    
    [_btnType1 setSelected:YES];
    [_btnType2 setSelected:NO];
    [_btnType3 setSelected:NO];
    
    mMode = ORDERMODE_PAYED;
    [self callGetOrderList:mMode pageno:mCurPageNum];
}

- (IBAction)onTapOrderType2:(id)sender
{
    mCurPageNum = 0;
    [mOrderList removeAllObjects];
    
    [_btnType1 setSelected:NO];
    [_btnType2 setSelected:YES];
    [_btnType3 setSelected:NO];
    
    mMode = ORDERMODE_WAIT;
    [self callGetOrderList:mMode pageno:mCurPageNum];
}

- (IBAction)onTapOrderType3:(id)sender
{
    mCurPageNum = 0;
    [mOrderList removeAllObjects];
    
    [_btnType1 setSelected:NO];
    [_btnType2 setSelected:NO];
    [_btnType3 setSelected:YES];
    
    mMode = ORDERMODE_RETURN;
    [self callGetOrderList:mMode pageno:mCurPageNum];
}
@end
