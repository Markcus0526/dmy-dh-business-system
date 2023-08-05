//
//  STServiceInfo.h
//  4S-C
//
//  Created by RyuCJ on 24/10/2012.
//  Copyright (c) 2012 PIC. All rights reserved.
//


#define SVCERR_SUCCESS                  0                       // 성공
#define SVCERR_FAILURE                  -1
#define SVCERR_TRIAL                    -2
#define SVCERR_NO_USER                  -3
#define SVCERR_NO_PHONE                 -4
#define SVCERR_EXIST_USER               -5
#define SVCERR_EXIST_PHONE              -6
#define SVCERR_SMS_TIMEOUT              -7
#define SVCERR_SMS_OVERFLOW_CNT         -8
#define SVCERR_PARAM_ERROR              -9

#define SVCMSG_SUCCESS                  @"操作成功"
#define SVCMSG_FAILURE                  @"网络不给力，操作失败"
#define SVCMSG_TRIAL                    @"当前版本就是Trial"
#define SVCMSG_NO_USER                  @"用户不存在"
#define SVCMSG_NO_PHONE                 @"手机号不存在"
#define SVCMSG_EXIST_USER               @"用户已存在"
#define SVCMSG_EXIST_PHONE              @"手机号已存在"
#define SVCMSG_SMS_TIMEOUT              @"超过SMS验证时间"
#define SVCMSG_SMS_OVERFLOW_CNT         @"超过当天SMS验证个数"
#define SVCMSG_PARAM_ERROR              @"参数错误"



//#define SVC_BASE_URL                        @"http://sypic.oicp.net:10202/Service.SVC/"
//#define SVC_BASE_URL                        @"http://192.168.1.32:10202/Service.SVC/"
#define SVC_BASE_URL                        @"http://218.60.131.41:10122/Service.SVC/"

#define SVCCMD_LOGIN                        @"LoginUser"
#define SVCCMD_REQ_VERIFYKEY                @"ReqVerifyKey"
#define SVCCMD_CONFIRM_VERIFYKEY            @"ConfirmVerifyKey"
#define SVCCMD_REGISTER                     @"RegisterUser"
#define SVCCMD_RESET_PWD                    @"ResetPassword"
#define SVCCMD_GET_USERINFO                 @"GetUserInfo"
#define SVCCMD_UPDATE_USERINFO              @"UpdateUserInfo"
#define SVCCMD_GET_SERVICELIST              @"GetServiceList"
#define SVCCMD_ADD_SERVICEITEM              @"AddServiceItem"
#define SVCCMD_GET_RECOMMGOODLIST           @"GetRecommendGoodList"
#define SVCCMD_GET_GOODKINDLIST             @"GetGoodKindList"
#define SVCCMD_GET_GOODSLIST                @"GetGoodsList"
#define SVCCMD_FIND_GOODSLIST               @"FindGoodsList"
#define SVCCMD_GET_GOODDETINFO              @"GetGoodDetailInfo"
#define SVCCMD_ADD_BUSINESSMONEY            @"AddBusinessMoney"
#define SVCCMD_GET_MYORDERLIST              @"GetMyOrderList"
#define SVCCMD_GET_GOODORDERINFO            @"GetGoodOrderInfo"
#define SVCCMD_UPLOAD_ORDERINFO             @"UploadOrderInfo"

