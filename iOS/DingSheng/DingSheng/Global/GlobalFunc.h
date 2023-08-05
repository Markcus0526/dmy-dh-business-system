//
//  Common.h
//  4S-C
//
//  Created by R CJ on 1/5/13.
//  Copyright (c) 2013 PIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "STDataInfo.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AdSupport/AdSupport.h>
#import "MACAddress.h"



#define MOVE_FROM_RIGHT     CATransition *animation = [CATransition animation]; \
                            [animation setDuration:0.3]; \
                            [animation setType:kCATransitionPush]; \
                            [animation setSubtype:kCATransitionFromRight]; \
                            [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]]; \
                            [[self.view.superview layer] addAnimation:animation forKey:@"SwitchToView"];

#define MOVE_FROM_LEFT      CATransition *animation = [CATransition animation]; \
                            [animation setDuration:0.3]; \
                            [animation setType:kCATransitionPush]; \
                            [animation setSubtype:kCATransitionFromLeft]; \
                            [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]]; \
                            [[self.view.superview layer] addAnimation:animation forKey:@"SwitchToView"];

#define SHOW_VIEW(ctrl)     MOVE_FROM_RIGHT \
                            [self presentViewController:ctrl animated:NO completion:nil];

#define SHOW_VIEW_IN_CELL(parent, ctrl)  \
                            CATransition *animation = [CATransition animation]; \
                            [animation setDuration:0.3]; \
                            [animation setType:kCATransitionPush]; \
                            [animation setSubtype:kCATransitionFromRight]; \
                            [animation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]]; \
                            [[parent.view.superview layer] addAnimation:animation forKey:@"SwitchToView"]; \
                            [parent presentViewController:ctrl animated:NO completion:nil];


#define BACK_VIEW           MOVE_FROM_LEFT \
                            [self dismissViewControllerAnimated:NO completion:nil];

#define TEST_NETWORK_RETURN if ([CommManager hasConnectivity] == NO) { \
                                [SVProgressHUD dismissWithError:@"没有网络连接"]; \
                                return; \
                            }

#define BACKGROUND_TEST_NETWORK_RETURN    if ([CommManager hasConnectivity] == NO) { \
                                                return; \
                                            }




typedef NS_ENUM(NSInteger, DEVICE_KIND) {
    IPHONE4= 1,
    IPHONE5,
    IPAD,
};

@interface GlobalFunc : NSObject {
}

+ (BOOL) isIOSVer7;
+ (float)getSystemVersion;

+ (void) makeErrorWindow : (NSString *)content TopOffset:(NSInteger)topOffset BottomOffset:(NSInteger)bottomOffset View:(UIView *)view;


+ (NSString*) getCurTime : (NSString*)fmt;

+ (NSInteger) phoneType;

+ (NSString *) getRealImagePath :(NSString *)path :(NSString *)rate :(NSString *)size;
+ (NSString *) getBackImagePath :(NSString *)path :(NSString *)rate :(NSString *)size;

+ (NSString*) base64forData:(NSData*)theData;
+ (NSData*) base64forString:(NSString*)theString;

+ (NSString *) appNameAndVersionNumberDisplayString;

+ (NSString *) md5:(NSString *) input;

+ (NSString*)getAdvertiseIdentifier;
+ (NSString*)getDeviceIDForVendor;
+ (NSString*)getDeviceMacAddress;       // used for IMEI

+ (void)callPhone : (NSString *)phoneNum;

@end
