//
//  MainSvcMgr.m
//  Yilebang
//
//  Created by KimOC on 12/18/13.
//  Copyright (c) 2013 KimOC. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AccountSvcMgr.h"
//#import "SBJson.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


//////////////////////////////////////////////////////////
#pragma mark - User Info Manager Interface

@implementation AccountSvcMgr

@synthesize delegate;


- (void) LoginUser : (NSString *)username password:(NSString*)password macaddr:(NSString *)macaddr;
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_LOGIN];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            macaddr, @"macaddr",
                            DEV_TYPE, @"devtype",
							nil];
    
    [httpClient postPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseLoginUser:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate loginUserResult:SVCERR_FAILURE userid:0 baseUrl:@""];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];

}

- (void) ReqVerifyKey : (NSString *)phonenum
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_REQ_VERIFYKEY];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            phonenum, @"phonenum",
							nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseReqVerifyKey:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate reqVerifyKeyResult:SVCERR_FAILURE];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) ConfirmVerifyKey : (NSString *)phonenum verifykey:(NSString *)verifykey
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_CONFIRM_VERIFYKEY];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            phonenum, @"phonenum",
                            verifykey, @"verifykey",
							nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseConfirmVerifyKey:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate confirmVerifyKeyResult:SVCERR_FAILURE];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) RegisterUser : (NSString *)username password:(NSString *)password phonenum:(NSString *)phonenum macaddr:(NSString *)macaddr
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_REGISTER];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            phonenum, @"phonenum",
                            macaddr, @"macaddr",
                            DEV_TYPE, @"devtype",
							nil];
    
    [httpClient postPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseRegisterUser:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate registerUserResult:SVCERR_FAILURE userid:0 baseUrl:@""];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) GetUserInfo : (long)uid
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_USERINFO];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", uid], @"uid",
							nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseUserInfo:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate getUserInfoResult:SVCERR_FAILURE datainfo:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) UpdateUserInfo : (long)uid username:(NSString *)username birthday:(NSString *)birthday
                   email:(NSString *)email phonenum:(NSString *)phonenum imgdata:(NSString *)imgdata
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_UPDATE_USERINFO];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", uid], @"uid",
                            username, @"username",
                            birthday, @"birthday",
                            email, @"email",
                            phonenum, @"phonenum",
                            imgdata, @"imgdata",
							nil];
    
    [httpClient postPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseUpdateUserInfo:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate updateUserInfoResult:SVCERR_FAILURE];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) GetMyOrderList : (long)uid mode:(enum EN_ORDERMODE)mode pageno:(int)pageno
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_GET_MYORDERLIST];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", uid], @"uid",
                            [NSString stringWithFormat:@"%d", mode], @"mode",
                            [NSString stringWithFormat:@"%d", pageno], @"pageno",
							nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseMyOrderList:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate getMyOrderListResult:SVCERR_FAILURE datalist:nil];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

- (void) ResetPassword : (long)uid phonenum:(NSString *)phonenum password:(NSString *)password
{
    NSMutableString *method = [NSMutableString string];
    [method appendString:SVC_BASE_URL];
    [method appendString:SVCCMD_RESET_PWD];
    
	NSURL *url = [NSURL URLWithString:SVC_BASE_URL];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld", uid], @"uid",
                            phonenum, @"phonenum",
                            password, @"password",
							nil];
    
    [httpClient getPath:method parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		 
		 [self parseResetPassword:responseStr];
		 
		 NSLog(@"Request Successful, response '%@'", responseStr);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 [delegate resetPasswordResult:SVCERR_FAILURE];
		 NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
     }];
}

/////////////////////////////////////////////////////////////////////////////
///////////////////////////////// event implementation //////////////////////
/////////////////////////////////////////////////////////////////////////////

#pragma mark - Service Event Implementation

- (void)parseLoginUser:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    long userid = 0;
//    STUserInfo * userInfo = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            userid = [[tmp1 objectForKey:SVCC_DATA] longValue];
            
//            NSDictionary * jsonDic = [tmp1 objectForKey:SVCC_DATA];
//            
//            userInfo = [[STUserInfo alloc] init];
//            [userInfo setValuesForKeysWithDictionary:jsonDic];
        }
    }
    
    [delegate loginUserResult:jsonRet userid:userid baseUrl:baseUrl];
}


- (void)parseReqVerifyKey:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
    }
    
    [delegate reqVerifyKeyResult:jsonRet];
}

- (void)parseConfirmVerifyKey:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
    }
    
    [delegate confirmVerifyKeyResult:jsonRet];
}

- (void)parseRegisterUser:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    long userid = 0;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            userid = [[tmp1 objectForKey:SVCC_DATA] longValue];
        }
    }
    
    [delegate registerUserResult:jsonRet userid:userid baseUrl:baseUrl];
}

- (void)parseUserInfo:(NSString *)responseStr
{
    NSError * e;
    NSInteger jsonRet = SVCERR_FAILURE;
    NSString * baseUrl = @"";
    STUserInfo * userInfo = nil;
    
    if (responseStr)
    {
        NSDictionary *tmp1 = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers                                                             error: &e];
        
        // get service result
        jsonRet = [[tmp1 objectForKey:SVCC_RET] intValue];
        baseUrl = [tmp1 objectForKey:SVCC_BASEURL];
        // check result
        if (jsonRet == SVCERR_SUCCESS)
        {
            
            NSDictionary * jsonDic = [tmp1 objectForKey:SVCC_DATA];
        
            userInfo = [[STUserInfo alloc] init];
            [userInfo setValuesForKeysWithDictionary:jsonDic];
        }
    }
    
    [delegate getUserInfoResult:jsonRet datainfo:userInfo];
}


- (void)parseUpdateUserInfo:(NSString *)responseStr
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
    
    [delegate updateUserInfoResult:jsonRet];
}


- (void)parseMyOrderList:(NSString *)responseStr
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
                STMyOrderInfo * orderinfo = [[STMyOrderInfo alloc] init];
                
                [orderinfo setValuesForKeysWithDictionary:item];
                [datalist addObject:orderinfo];
            }
            
        }
    }
    
    [delegate getMyOrderListResult:jsonRet datalist:datalist];
}


- (void)parseResetPassword:(NSString *)responseStr
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
    
    [delegate resetPasswordResult:jsonRet];
}


@end