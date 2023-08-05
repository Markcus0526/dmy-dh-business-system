//
//  MainSvcMgr.h
//  Yilebang
//
//  Created by KimOC on 12/18/13.
//  Copyright (c) 2013 KimOC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccountSvcDelegate;

@interface AccountSvcMgr : NSObject {
}

@property(strong, nonatomic) id<AccountSvcDelegate> delegate;

- (void) LoginUser : (NSString *)username password:(NSString*)password macaddr:(NSString *)macaddr;
- (void) ReqVerifyKey : (NSString *)phonenum;
- (void) ConfirmVerifyKey : (NSString *)phonenum verifykey:(NSString *)verifykey;
- (void) RegisterUser : (NSString *)username password:(NSString *)password phonenum:(NSString *)phonenum macaddr:(NSString *)macaddr;
- (void) GetUserInfo : (long)uid;
- (void) UpdateUserInfo : (long)uid username:(NSString *)username birthday:(NSString *)birthday
                   email:(NSString *)email phonenum:(NSString *)phonenum imgdata:(NSString *)imgdata;
- (void) GetMyOrderList : (long)uid mode:(enum EN_ORDERMODE)mode pageno:(int)pageno;
- (void) ResetPassword : (long)uid phonenum:(NSString *)phonenum password:(NSString *)password;

@end

// service protocol
@protocol AccountSvcDelegate <NSObject>

@optional
- (void) loginUserResult : (NSInteger)result userid:(long)userid baseUrl:(NSString *)baseUrl;
- (void) reqVerifyKeyResult : (NSInteger)result;
- (void) confirmVerifyKeyResult : (NSInteger)result;
- (void) registerUserResult : (NSInteger)result userid:(long)userid baseUrl:(NSString *)baseUrl;
- (void) getUserInfoResult : (NSInteger)result datainfo:(STUserInfo *)datainfo;
- (void) updateUserInfoResult : (NSInteger)result;
- (void) getMyOrderListResult : (NSInteger)result datalist:(NSMutableArray *)datalist;
- (void) resetPasswordResult : (NSInteger)result;

@end
