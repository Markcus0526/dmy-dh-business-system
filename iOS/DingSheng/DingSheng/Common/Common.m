//
//  Common.m
//  4S-C
//
//  Created by R CJ on 1/5/13.
//  Copyright (c) 2013 PIC. All rights reserved.
//

#import "Common.h"

// Common variables

NSString *      _deviceToken = @"";
NSString *      _baseUrl = @"";
long            _userId = 0;
STUserInfo *    _userInfo = nil;


#define _MAXLENGTH       50


@implementation Common

+ (void) setDeviceToken : (NSString*)newDeviceToken
{
    _deviceToken = newDeviceToken;
}

+ (NSString*) deviceToken
{
    return _deviceToken;
}

+ (void) setUserInfo : (STUserInfo*)userInfo;
{
    _userInfo = userInfo;
}

+ (STUserInfo*) userInfo
{
    return _userInfo;
}

+ (void) setUserId : (long)userId
{
    _userId = userId;
}

+ (long) userId
{
    return _userId;
}

+ (NSString*) baseUrl
{
    if (_baseUrl == nil) {
        return @"";
    }
    
    return _baseUrl;
}

+ (void) setBaseUrl:(NSString *)baseUrl
{
    if (baseUrl == nil) {
        return;
    }
    
    _baseUrl = baseUrl;
}


+ (NSInteger ) MAXLENGTH
{
    return _MAXLENGTH;
}


@end
