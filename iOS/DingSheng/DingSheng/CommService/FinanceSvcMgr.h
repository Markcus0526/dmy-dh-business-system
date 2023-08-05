//
//  GoodsSvcMgr.h
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FinanceSvcDelegate;

@interface FinanceSvcMgr : NSObject {
}

@property(strong, nonatomic) id<FinanceSvcDelegate> delegate;

- (void) GetServiceList : (enum EN_SVCMODE)mode;
- (void) AddServiceItem : (long)uid mode:(enum EN_SVCMODE)mode cardno:(NSString *)cardno name:(NSString *)name
                phonenum:(NSString *)phonenum identino:(NSString *)identino address:(NSString *)address note:(NSString *)note;

@end

// service protocol
@protocol FinanceSvcDelegate <NSObject>

@optional
- (void) serviceListResult : (NSInteger)result datalist:(NSMutableArray *)datalist;
- (void) addServiceItemResult : (NSInteger)result;

@end