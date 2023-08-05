//
//  Common.m
//  4S-C
//
//  Created by R CJ on 1/5/13.
//  Copyright (c) 2013 PIC. All rights reserved.
//

#import "Config.h"

#define KEY_LOGIN_NAME              @"loginName"
#define KEY_LOGIN_PASSWORD          @"loginPassword"

@implementation Config


+ (void) setLoginName : (NSString*)newLoginName
{
    [[NSUserDefaults standardUserDefaults] setObject:newLoginName forKey:KEY_LOGIN_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) loginName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:KEY_LOGIN_NAME];
}

+ (void) setLoginPassword : (NSString*)newLoginPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:newLoginPassword forKey:KEY_LOGIN_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) loginPassword
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:KEY_LOGIN_PASSWORD];
}


@end
