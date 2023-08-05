//
//  Common.h
//  4S-C
//
//  Created by R CJ on 1/5/13.
//  Copyright (c) 2013 PIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface Common : NSObject {
}

+ (void) setDeviceToken : (NSString*)newDeviceToken;
+ (NSString*) deviceToken;

+ (void) setUserInfo : (STUserInfo*)userInfo;
+ (STUserInfo*) userInfo;

+ (void) setUserId : (long)userId;
+ (long) userId;

+ (NSString*) baseUrl;
+ (void) setBaseUrl : (NSString *)baseUrl;

+ (NSInteger) MAXLENGTH;


@end
