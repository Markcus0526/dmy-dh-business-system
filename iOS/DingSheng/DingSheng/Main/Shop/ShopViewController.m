//
//  ShopViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ShopViewController.h"
#import "MJRefresh.h"
#import "ProdDetailViewController.h"
#import "ProdSearchViewController.h"

@implementation ShopGoodsTableCell

@end


@interface ShopViewController ()
{
    NSMutableArray *            mKindList;
    NSMutableArray *            mGoodsList;
    
    NSInteger                   mCurPageNum;
    long                        mCurKindId;
}

@end


#define ITEM_SPACE                      5
#define ITEM_TITLE_HEIGHT               20
#define GOODCELL_HEIGHT                 80
#define GOODCELL_ID                     @"cellShopGood"

@implementation ShopViewController

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
    if ([segue.identifier isEqualToString:@"segueFromShopToDetail"])
    {
        ProdDetailViewController * destCtrl = (ProdDetailViewController *)segue.destinationViewController;
        destCtrl.mProdId = [(STGoodSummary *)sender uid];
    }
    else if ([segue.identifier isEqualToString:@"segueFromShopToSearch"])
    {
        ProdSearchViewController * destCtrl = (ProdSearchViewController *)segue.destinationViewController;
        destCtrl.mKindId = mCurKindId;
        destCtrl.mMode = 1;
    }
}



///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    [self initNavButtons];
    // initialize ui controls
    [self setupTableRefresh];
    
    // get recommend goods list
    [self callGetGoodKindList];
}


- (void) initNavButtons
{
    UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onTapNavSearch)];
    
    UIBarButtonItem * account = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"usericon_gray.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onTapNavAccount)];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:account, search, nil];
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
 * Show good's kind list in scroll view
 */
- (void) showKindList
{
    if (mKindList == nil)
        return;
    
    // calculate scroll content size
    int itemHeight = _kindScrollView.bounds.size.height;
    int itemWidth = itemHeight - ITEM_TITLE_HEIGHT;
    
    CGFloat contWidth = itemWidth * mKindList.count;
    CGFloat contHeight = itemHeight;
    [_kindScrollView setContentSize:CGSizeMake(contWidth, contHeight)];
    
    // add kind list
    for (int i = 0; i < mKindList.count; i++) {
        STGoodKind * kindInfo = (STGoodKind *)[mKindList objectAtIndex:i];
        // make child view
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, itemHeight)];
        [childView setBackgroundColor:[UIColor clearColor]];
        // add imageview
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ITEM_SPACE, ITEM_SPACE, itemWidth - ITEM_SPACE * 2, itemHeight - ITEM_SPACE * 2 - ITEM_TITLE_HEIGHT)];
        NSString * imgurl = [NSString stringWithFormat:@"%@%@", [Common baseUrl], kindInfo.imgpath];
        [imgView setImageWithURL:[NSURL URLWithUnicodeString:imgurl] placeholderImage:[UIImage imageNamed:@"ic_stub.png"]];
        [childView addSubview:imgView];
        // add title
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(ITEM_SPACE, itemHeight - ITEM_SPACE - ITEM_TITLE_HEIGHT, itemWidth - ITEM_SPACE * 2, ITEM_TITLE_HEIGHT)];
        [title setText:kindInfo.title];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [childView addSubview:title];
        
        // add button
        UIButton * btnBG = [[UIButton alloc] initWithFrame:childView.bounds];
        [btnBG setTag:i];
        [btnBG setBackgroundColor:[UIColor clearColor]];
        [btnBG addTarget:self action:@selector(onTapGoodKind:) forControlEvents:UIControlEventTouchUpInside];
        [childView addSubview:btnBG];
        
        // add child view to scrollview
        [_kindScrollView addSubview:childView];
    }
    
    // get good list
    if (mKindList.count > 0) {
        STGoodKind * fstKind = (STGoodKind *)[mGoodsList objectAtIndex:0];
        mCurPageNum = 0;
        [self callGetGoodsList:fstKind.uid pageno:mCurPageNum];
    }
}

/**
 * implementation of good kind click event
 */
- (void)onTapGoodKind:(UIButton *)sender
{
    STGoodKind * kindinfo = [mKindList objectAtIndex:sender.tag];
    
    if (mGoodsList != nil) {
        [mGoodsList removeAllObjects];
    }
    // call get goods list service
    mCurPageNum = 0;
    mCurKindId = kindinfo.uid;
    [self callGetGoodsList:mCurKindId pageno:mCurPageNum];
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
    [self callGetGoodsList:mCurKindId pageno:mCurPageNum];
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
    ShopGoodsTableCell * goodCell = (ShopGoodsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(goodCell == nil)
    {
        goodCell = [[ShopGoodsTableCell alloc]init];
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
    
    STGoodSummary * param = [mGoodsList objectAtIndex:indexPath.row];
    // show good detail view
    [self performSegueWithIdentifier:@"segueFromShopToDetail" sender:param];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get good kind list service
 */
- (void) callGetGoodKindList
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] goodsSvcMgr].delegate = self;
    [[[CommManager getCommMgr] goodsSvcMgr] GetGoodKindList];
}

- (void) goodKindListResult:(NSInteger)result datalist:(NSMutableArray *)datalist
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set good kind data list
        mKindList = datalist;
        [self showKindList];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

/**
 * call get good kind list service
 */
- (void) callGetGoodsList : (long)kindid pageno:(NSInteger)pageno
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] goodsSvcMgr].delegate = self;
    [[[CommManager getCommMgr] goodsSvcMgr] GetGoodsList:0 kindid:kindid pageno:pageno];  // 0 : 特惠
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


///////////////////////////////////////////////////////////////////////////
#pragma mark - UI Event
/**
 * tapped search navigation button item
 */
- (void) onTapNavSearch
{
    // Show search view controller
    [self performSegueWithIdentifier:@"segueFromShopToSearch" sender:nil];
}

/**
 * tapped account navigation button item
 */
- (void) onTapNavAccount
{
    [self onTapAccount:self];
}

@end
