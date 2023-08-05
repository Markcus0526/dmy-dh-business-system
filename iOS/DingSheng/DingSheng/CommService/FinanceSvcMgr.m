//
//  GoodsSvcMgr.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "FinanceSvcMgr.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AccountSvcMgr.h"
//#import "SBJson.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


//////////////////////////////////////////////////////////
#pragma mark - Finance Manager Interface

@implementation FinanceSvcMgr

@synthesize delegate;


- (void) GetServiceList : (enum EN_SVCMODE)mode;
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_SERVICELIST];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%d", mode], @"mode",
                            nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseServiceList:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate serviceListResult:SVCERR_FAILURE datalist:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) AddServiceItem : (long)uid mode:(enum EN_SVCMODE)mode cardno:(NSString *)cardno name:(NSString *)name
                phonenum:(NSString *)phonenum identino:(NSString *)identino address:(NSString *)address note:(NSString *)note
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_ADD_SERVICEITEM];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", uid], @"uid",
                            [NSString stringWithFormat:@"%d", mode], @"mode",
                            cardno, @"cardno",
                            name, @"name",
                            phonenum, @"phonenum",
                            identino, @"identino",
                            address, @"address",
                            note, @"note",
                            nil];
    
    [httpClient postPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseAddServiceItem:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate addServiceItemResult:SVCERR_FAILURE];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

/////////////////////////////////////////////////////////////////////////////
///////////////////////////////// event implementation //////////////////////
/////////////////////////////////////////////////////////////////////////////

#pragma mark - Service Event Implementation

- (void)parseServiceList:(NSString *)responseStr
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
                STServiceInfo * datainfo = [[STServiceInfo alloc] init];
                
                [datainfo setValuesForKeysWithDictionary:item];
                [datalist addObject:datainfo];
            }
            
        }
    }
    
    [delegate serviceListResult:jsonRet datalist:datalist];
}

- (void)parseAddServiceItem:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            
        }
    }
    
    [delegate addServiceItemResult:jsonRet];
}

@end
