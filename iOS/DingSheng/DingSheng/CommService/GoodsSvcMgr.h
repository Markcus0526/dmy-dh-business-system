//
//  GoodsSvcMgr.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoodsSvcDelegate;

@interface GoodsSvcMgr : NSObject {
}

@property(strong, nonatomic) id<GoodsSvcDelegate> delegate;

- (void) GetRecommendGoodList;
- (void) GetGoodKindList;
- (void) GetGoodsList : (NSInteger)mode kindid:(NSInteger)kindid pageno:(NSInteger)pageno;
- (void) GetGoodDetailInfo : (long)goodid;
- (void) GetGoodOrderInfo : (long)uid goodid:(long)goodid;
- (void) FindGoodsList : (NSInteger)mode kindid:(NSInteger)kindid goodname:(NSString *)goodname pageno:(NSInteger)pageno;

@end

// service protocol
@protocol GoodsSvcDelegate <NSObject>

@optional
- (void) recommGoodListResult : (NSInteger)result datalist:(NSMutableArray *)datalist;
- (void) goodKindListResult : (NSInteger)result datalist:(NSMutableArray *)datalist;
- (void) goodsListResult : (NSInteger)result datalist:(NSMutableArray *)datalist;
- (void) goodDetailResult : (NSInteger)result datainfo:(STGoodDetail *)datainfo;
- (void) goodOrderInfoResult : (NSInteger)result datainfo:(STGoodOrderInfo *)datainfo;
- (void) findGoodsListResult : (NSInteger)result datalist:(NSMutableArray *)datainfo;

@end