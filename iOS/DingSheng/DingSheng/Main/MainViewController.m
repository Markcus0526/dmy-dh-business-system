//
//  MainViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "MainViewController.h"
#import "NSLayoutConstraint+HAWHelpers.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize _vwSliderContainer;

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
    // initialize ui controls
    
    // get recommend goods list
    [self callGetRecommGoodList];
}


- (void) loadAdvertiseView
{
    if (mRecommGoodList.count < 1)
        return;
    
    bannerImages = [[NSMutableArray alloc] initWithCapacity:0];
    if (mRecommGoodList.count > 0)
    {
        STRecommGood *aBanner = [mRecommGoodList objectAtIndex:mRecommGoodList.count - 1];
        [bannerImages addObject:[NSString stringWithFormat:@"%@%@", [Common baseUrl], aBanner.imgpath]];
    }
    for (int i = 0; i < mRecommGoodList.count - 1; i++)
    {
        STRecommGood *aBanner = [mRecommGoodList objectAtIndex:i];
        [bannerImages addObject:[NSString stringWithFormat:@"%@%@", [Common baseUrl], aBanner.imgpath]];
    }
    
    //    imageIndex = 0;
    int length = [bannerImages count];
    //    imageCount = length;
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
    
    _bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, _vwSliderContainer.frame.size.width, _vwSliderContainer.frame.size.height) delegate:self imageItems:itemArray isAuto:YES array:bannerImages isOnline:YES defImage:defImage];
    [_bannerView scrollToIndex:0];

    [_vwSliderContainer addSubview:_bannerView];
    
    [NSLayoutConstraint leftOfChild:_bannerView toLeftOfParent:_vwSliderContainer withFixedMargin:0];
    [NSLayoutConstraint topOfChild:_bannerView toTopOfParent:_vwSliderContainer withFixedMargin:0];
    [NSLayoutConstraint rightOfChild:_bannerView toRightOfParent:_vwSliderContainer withFixedMargin:0];
    [NSLayoutConstraint bottomOfChild:_bannerView toBottomOfParent:_vwSliderContainer];
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
 * call login user service
 */
- (void) callGetRecommGoodList
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] goodsSvcMgr].delegate = self;
    [[[CommManager getCommMgr] goodsSvcMgr] GetRecommendGoodList];
}

- (void) recommGoodListResult:(NSInteger)result datalist:(NSMutableArray *)datalist
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set reccommend data list
        mRecommGoodList = datalist;
        [self loadAdvertiseView];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

@end
