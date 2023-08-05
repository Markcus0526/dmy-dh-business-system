//
//  ProdDetailViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ProdDetailViewController.h"
#import "NSLayoutConstraint+HAWHelpers.h"
#import "PubOrderViewController.h"

@interface ProdDetailViewController ()
{
    STGoodDetail *              mDetInfo;
    
    SGFocusImageFrame *         _bannerView;
    NSMutableArray *            bannerImages;
}

@end

@implementation ProdDetailViewController

@synthesize mProdId;

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
    if ([segue.identifier isEqualToString:@"segueFromDetailToPay"]){
        PubOrderViewController * destCtrl = (PubOrderViewController *)segue.destinationViewController;
        destCtrl.mProdId = mDetInfo.goodid;
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
    [self callGetGoodDetailInfo];
}

- (void) updateUI
{
    // set detail info
    [self loadAdvertiseView];
    
    [_lblName setText:mDetInfo.name];
    [_lblPrice setText:[NSString stringWithFormat:@"%d", mDetInfo.price]];
    [_lblShopAddr setText:mDetInfo.shopaddr];
    [_lblShopPhone setText:mDetInfo.shopphone];
    [_txtBuyDesc setText:mDetInfo.buydesc];
    // load web view content
    [_webGoodDesc loadHTMLString:mDetInfo.gooddesc baseURL:nil];
}


- (void) loadAdvertiseView
{
    bannerImages = [[NSMutableArray alloc] init];
    if (![NSString isNullOrEmpty:mDetInfo.imgpath1]) {
        [bannerImages addObject:[NSString stringWithFormat:@"%@%@", [Common baseUrl], mDetInfo.imgpath1]];
    }
    if (![NSString isNullOrEmpty:mDetInfo.imgpath2]) {
        [bannerImages addObject:[NSString stringWithFormat:@"%@%@", [Common baseUrl], mDetInfo.imgpath2]];
    }
    if (![NSString isNullOrEmpty:mDetInfo.imgpath3]) {
        [bannerImages addObject:[NSString stringWithFormat:@"%@%@", [Common baseUrl], mDetInfo.imgpath3]];
    }
    if (![NSString isNullOrEmpty:mDetInfo.imgpath4]) {
        [bannerImages addObject:[NSString stringWithFormat:@"%@%@", [Common baseUrl], mDetInfo.imgpath4]];
    }
    
    NSInteger length = [bannerImages count];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"title%d",i],@"title" ,nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    
    
    UIImage * defImage = [UIImage imageNamed:@"ic_stub.png"];
    
    _bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, _vwImgContainer.frame.size.width, _vwImgContainer.frame.size.height) delegate:self imageItems:itemArray isAuto:YES array:bannerImages isOnline:YES defImage:defImage];
    [_bannerView scrollToIndex:0];
    
    [_vwImgContainer addSubview:_bannerView];
    
    [NSLayoutConstraint leftOfChild:_bannerView toLeftOfParent:_vwImgContainer withFixedMargin:0];
    [NSLayoutConstraint topOfChild:_bannerView toTopOfParent:_vwImgContainer withFixedMargin:0];
    [NSLayoutConstraint rightOfChild:_bannerView toRightOfParent:_vwImgContainer withFixedMargin:0];
    [NSLayoutConstraint bottomOfChild:_bannerView toBottomOfParent:_vwImgContainer];
}


#pragma mark - Image Slider Delegate
- (void) foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index
{
    
}

- (void) foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get good detail info service
 */
- (void) callGetGoodDetailInfo
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] goodsSvcMgr].delegate = self;
    [[[CommManager getCommMgr] goodsSvcMgr] GetGoodDetailInfo:mProdId];
}

- (void) goodDetailResult:(NSInteger)result datainfo:(STGoodDetail *)datainfo
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set good kind data list
        mDetInfo = datainfo;
        [self updateUI];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}


- (IBAction)onTapPhone:(id)sender
{
    // call phone
    [GlobalFunc callPhone:mDetInfo.shopphone];
}
@end
