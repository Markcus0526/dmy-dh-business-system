//
//  STDataInfo.h
//  FourService
//
//  Created by RyuCJ on 24/11/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

#define  SEX_MALE           @"0"
#define  SEX_FEMALE         @"1"

#define  EVAL_HIGH          2
#define  EVAL_MEDIUM        1
#define  EVAL_LOW           0


enum EN_SVCMODE
{
    SVCMODE_BANK = 0,
    SVCMODE_CREDIT,
    SVCMODE_INSURANCE,
    SVCMODE_PROPERTY,
    SVCMODE_SMALLPROD
};

enum EN_ORDERMODE
{
    ORDERMODE_PAYED = 0,
    ORDERMODE_WAIT,
    ORDERMODE_RETURN
};

/********************************* User Info ********************************/
@interface STUserInfo : NSObject

@property (nonatomic, readwrite) long  uid;
@property (nonatomic, retain) NSString *    userid;
@property (nonatomic, retain) NSString *    username;
@property (nonatomic, retain) NSString *    birth;
@property (nonatomic, retain) NSString *    email;
@property (nonatomic, readwrite) NSInteger  ordercount;
@property (nonatomic, retain) NSString *    imgpath;
@property (nonatomic, retain) NSString *    phonenum;
@property (nonatomic, readwrite) NSInteger  credit;

@end


/********************************* Recommend Good ****************************/
@interface STRecommGood : NSObject

@property (nonatomic, readwrite) long  uid;
@property (nonatomic, retain) NSString *    goodname;
@property (nonatomic, retain) NSString *    imgpath;

@end


/********************************* Good Kind List ****************************/
@interface STGoodKind : NSObject

@property (nonatomic, readwrite) long  uid;
@property (nonatomic, retain) NSString *    title;
@property (nonatomic, retain) NSString *    imgpath;

@end


/********************************* Goods Summary ****************************/
@interface STGoodSummary : NSObject

@property (nonatomic, readwrite) long  uid;
@property (nonatomic, retain) NSString *    name;
@property (nonatomic, retain) NSString *    imgpath;
@property (nonatomic, retain) NSString *    noti;
@property (nonatomic, readwrite) int        price;
@property (nonatomic, readwrite) int        selledcount;

@end


/********************************* Goods Detail ****************************/
@interface STGoodDetail : NSObject

@property (nonatomic, readwrite) long       goodid;
@property (nonatomic, retain) NSString *    name;
@property (nonatomic, readwrite) int        price;
@property (nonatomic, retain) NSString *    imgpath1;
@property (nonatomic, retain) NSString *    imgpath2;
@property (nonatomic, retain) NSString *    imgpath3;
@property (nonatomic, retain) NSString *    imgpath4;
@property (nonatomic, retain) NSString *    gooddesc;
@property (nonatomic, retain) NSString *    shopaddr;
@property (nonatomic, retain) NSString *    shopphone;
@property (nonatomic, retain) NSString *    buydesc;

@end


/********************************* Goods Detail ****************************/
@interface STGoodOrderInfo : NSObject

@property (nonatomic, readwrite) long       goodid;
@property (nonatomic, retain) NSString *    goodname;
@property (nonatomic, readwrite) int        price;
@property (nonatomic, readwrite) int        count;
@property (nonatomic, readwrite) int        usingmark;
@property (nonatomic, readwrite) int        marklimit;
@property (nonatomic, readwrite) int        usermark;
@property (nonatomic, retain) NSString *    userphone;
@property (nonatomic, readwrite) int        isreject;

@end


/********************************* Service Info ****************************/
@interface STServiceInfo : NSObject

@property (nonatomic, readwrite) long       uid;
@property (nonatomic, retain) NSString *    title;
@property (nonatomic, retain) NSString *    content;

@end


/********************************* My Order Info ****************************/
@interface STMyOrderInfo : NSObject

@property (nonatomic, readwrite) long       saleid;
@property (nonatomic, readwrite) long       goodid;
@property (nonatomic, retain) NSString *    imgpath;
@property (nonatomic, retain) NSString *    goodname;
@property (nonatomic, retain) NSString *    gooddesc;
@property (nonatomic, readwrite) int        evalstatus;
@property (nonatomic, readwrite) int        salestatus;
@property (nonatomic, readwrite) int        rejectstatus;

@end



