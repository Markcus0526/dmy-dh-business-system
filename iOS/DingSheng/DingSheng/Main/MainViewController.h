//
//  MainViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface MainViewController : SuperViewController <GoodsSvcDelegate, SGFocusImageFrameDelegate>
{
    SGFocusImageFrame *             _bannerView;
    NSMutableArray  *               bannerImages;
    NSMutableArray  *               mRecommGoodList;
}

@property (weak, nonatomic) IBOutlet UIView * _vwSliderContainer;

@end
