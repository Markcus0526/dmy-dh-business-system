//
//  CommManager.h
//  FourService
//
//  Created by RyuCJ on 24/10/2012.
//  Copyright (c) 2012 PIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountSvcMgr.h"
#import "GoodsSvcMgr.h"
#import "FinanceSvcMgr.h"

/////////////////////////////////////////////////////////////
#pragma mark - Communication Manager Interface
@interface CommManager  :NSObject {

    AccountSvcMgr * accountSvcMgr;
    GoodsSvcMgr * goodsSvcMgr;
    FinanceSvcMgr * financeSvcMgr;
    
    CommManager *   commMgr;
}

+ (CommManager *)getCommMgr;
+ (BOOL)hasConnectivity;
- (void)loadCommModules;
+ (NSString *)getRetMsg:(NSInteger)retVal;


@property (nonatomic, retain) AccountSvcMgr * accountSvcMgr;
@property (nonatomic, retain) GoodsSvcMgr * goodsSvcMgr;
@property (nonatomic, retain) FinanceSvcMgr * financeSvcMgr;

@property (nonatomic, retain) CommManager *commMgr;

@end

