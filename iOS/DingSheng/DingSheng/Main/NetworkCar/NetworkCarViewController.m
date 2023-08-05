//
//  NetworkCarViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "NetworkCarViewController.h"
#import "MJRefresh.h"
#import "ProdDetailViewController.h"

@implementation NetCarGoodsTableCell

@end

@interface NetworkCarViewController ()
{
    NSMutableArray *            mGoodsList;
    
    NSInteger                   mCurPageNum;
}
@end


#define ITEM_SPACE                      5
#define ITEM_TITLE_HEIGHT               20
#define GOODCELL_HEIGHT                 80
#define GOODCELL_ID                     @"cellNetCarGood"


@implementation NetworkCarViewController

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
    if ([segue.identifier isEqualToString:@"segueFromNetworkCarToDetail"]){
        ProdDetailViewController * destCtrl = (ProdDetailViewController *)segue.destinationViewController;
        destCtrl.mProdId = [(STGoodSummary *)sender uid];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    // initialize ui controls
    [self setupTableRefresh];
    
    mCurPageNum = 0;
    // get network car goods list
    [self callGetGoodsList:4 pageno:mCurPageNum];
}


- (void)setupTableRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tblGoodList addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tblGoodList.footerPullToRefreshText = MSG_TBLFOOTER_PULL;
    _tblGoodList.footerReleaseToRefreshText = MSG_TBLFOOTER_RELEASE;
    _tblGoodList.footerRefreshingText = MSG_TBLFOOTER_REFRESHING;
}


/**
 * update goods tableview
 */
- (void) updateGoodsTable
{
    [_tblGoodList reloadData];
    
    // stop refreshing
    [_tblGoodList footerEndRefreshing];
}

#pragma mark - Pull refresh event

- (void)footerRereshing
{
    mCurPageNum++;
    [self callGetGoodsList:1 pageno:mCurPageNum];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - delegate event of main table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mGoodsList == nil)
        return 0;
    
    return [mGoodsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return GOODCELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (mGoodsList == nil)
        return nil;
    
	static NSString *cellIdentifier = GOODCELL_ID;
    NetCarGoodsTableCell * goodCell = (NetCarGoodsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(goodCell == nil)
    {
        goodCell = [[NetCarGoodsTableCell alloc] init];
    }
    //UITableViewCell *cell = nil;
    STGoodSummary * dataInfo = [mGoodsList objectAtIndex:indexPath.row];
    
    goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // initialize cell info
    NSString * imgurl = [NSString stringWithFormat:@"%@%@", [Common baseUrl], dataInfo.imgpath];
    [goodCell.imgGood setImageWithURL:[NSURL URLWithUnicodeString:imgurl] placeholderImage:[UIImage imageNamed:@"ic_stub.png"]];
    [goodCell.lblTitle setText:dataInfo.name];
    [goodCell.lblDesc setText:dataInfo.noti];
    [goodCell.lblPrice setText:[NSString stringWithFormat:@"%d", dataInfo.price]];
    
	return goodCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([mGoodsList count] <= indexPath.row)
        return;
    
    STGoodSummary * param = (STGoodSummary *)[mGoodsList objectAtIndex:indexPath.row];
    // show good detail view
    [self performSegueWithIdentifier:@"segueFromNetworkCarToDetail" sender:param];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get good kind list service
 */
- (void) callGetGoodsList : (long)kindid pageno:(NSInteger)pageno
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] goodsSvcMgr].delegate = self;
    [[[CommManager getCommMgr] goodsSvcMgr] GetGoodsList:2 kindid:kindid pageno:pageno];    
}

- (void) goodsListResult:(NSInteger)result datalist:(NSMutableArray *)datalist
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set goods data list
        if([datalist count] > 0) {
            if (mGoodsList == nil) {
                mGoodsList = datalist;
            } else {
                [mGoodsList addObjectsFromArray:datalist];
            }
        }
        [self updateGoodsTable];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

@end
