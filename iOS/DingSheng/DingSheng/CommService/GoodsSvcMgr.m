//
//  GoodsSvcMgr.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "GoodsSvcMgr.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AccountSvcMgr.h"
//#import "SBJson.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


//////////////////////////////////////////////////////////
#pragma mark - User Info Manager Interface

@implementation GoodsSvcMgr

@synthesize delegate;


- (void) GetRecommendGoodList
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_RECOMMGOODLIST];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseRecommGoodList:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate recommGoodListResult:SVCERR_FAILURE datalist:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) GetGoodKindList
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_GOODKINDLIST];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseGoodKindList:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate goodKindListResult:SVCERR_FAILURE datalist:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) GetGoodsList : (NSInteger)mode kindid:(NSInteger)kindid pageno:(NSInteger)pageno
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_GOODSLIST];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", (long)mode], @"mode",
                            [NSString stringWithFormat:@"%d", kindid], @"kindid",
                            [NSString stringWithFormat:@"%d", pageno], @"pageno",
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseGoodsList:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate goodsListResult:SVCERR_FAILURE datalist:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) GetGoodDetailInfo : (long)goodid
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_GOODDETINFO];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", goodid], @"goodid",
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseGoodDetail:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate goodDetailResult:SVCERR_FAILURE datainfo:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) GetGoodOrderInfo : (long)uid goodid:(long)goodid
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_GOODORDERINFO];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", uid], @"uid",
                            [NSString stringWithFormat:@"%ld", goodid], @"goodid",
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseGoodOrderInfo:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate goodOrderInfoResult:SVCERR_FAILURE datainfo:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) FindGoodsList : (NSInteger)mode kindid:(NSInteger)kindid goodname:(NSString *)goodname pageno:(NSInteger)pageno
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_FIND_GOODSLIST];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", (long)mode], @"mode",
                            [NSString stringWithFormat:@"%d", kindid], @"kindid",
                            goodname, @"goodname",
                            [NSString stringWithFormat:@"%d", pageno], @"pageno",
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseFindGoodsList:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate findGoodsListResult:SVCERR_FAILURE datalist:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

/////////////////////////////////////////////////////////////////////////////
///////////////////////////////// event implementation //////////////////////
/////////////////////////////////////////////////////////////////////////////

#pragma mark - Service Event Implementation

- (void)parseRecommGoodList:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    NSMutableArray * datalist = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            NSMutableArray * jsonArray = [tmp1 objectForKey:SVCC_DATA];
            
            // make child app data list
            datalist = [[NSMutableArray alloc] init];
            for (NSDictionary * item in jsonArray)
            {
                STRecommGood * goodinfo = [[STRecommGood alloc] init];
                
                [goodinfo setValuesForKeysWithDictionary:item];
                [datalist addObject:goodinfo];
            }
            
        }
    }
    
    [delegate recommGoodListResult:jsonRet datalist:datalist];
}

- (void)parseGoodKindList:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    NSMutableArray * datalist = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            NSMutableArray * jsonArray = [tmp1 objectForKey:SVCC_DATA];
            
            // make child item data list
            datalist = [[NSMutableArray alloc] init];
            for (NSDictionary * item in jsonArray)
            {
                STGoodKind * goodkind = [[STGoodKind alloc] init];
                
                [goodkind setValuesForKeysWithDictionary:item];
                [datalist addObject:goodkind];
            }
            
        }
    }
    
    [delegate goodKindListResult:jsonRet datalist:datalist];
}


- (void)parseGoodsList:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    NSMutableArray * datalist = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            NSMutableArray * jsonArray = [tmp1 objectForKey:SVCC_DATA];
            
            // make child item data list
            datalist = [[NSMutableArray alloc] init];
            for (NSDictionary * item in jsonArray)
            {
                STGoodSummary * goodinfo = [[STGoodSummary alloc] init];
                
                [goodinfo setValuesForKeysWithDictionary:item];
                [datalist addObject:goodinfo];
            }
            
        }
    }
    
    [delegate goodsListResult:jsonRet datalist:datalist];
}

- (void) parseGoodDetail:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    STGoodDetail * datainfo = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            NSDictionary * jsonObject = [tmp1 objectForKey:SVCC_DATA];
            
            // make detail info
            datainfo = [[STGoodDetail alloc] init];
            [datainfo setValuesForKeysWithDictionary:jsonObject];
        }
    }
    
    [delegate goodDetailResult:jsonRet datainfo:datainfo];
}

- (void)parseGoodOrderInfo:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    STGoodOrderInfo * datainfo = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            NSDictionary * jsonObject = [tmp1 objectForKey:SVCC_DATA];
            
            // make detail info
            datainfo = [[STGoodOrderInfo alloc] init];
            [datainfo setValuesForKeysWithDictionary:jsonObject];
        }
    }
    
    [delegate goodOrderInfoResult:jsonRet datainfo:datainfo];
}

- (void)parseFindGoodsList:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    NSMutableArray * datalist = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            NSMutableArray * jsonArray = [tmp1 objectForKey:SVCC_DATA];
            
            // make child item data list
            datalist = [[NSMutableArray alloc] init];
            for (NSDictionary * item in jsonArray)
            {
                STGoodSummary * goodinfo = [[STGoodSummary alloc] init];
                
                [goodinfo setValuesForKeysWithDictionary:item];
                [datalist addObject:goodinfo];
            }
            
        }
    }
    
    [delegate findGoodsListResult:jsonRet datalist:datalist];
}

@end
