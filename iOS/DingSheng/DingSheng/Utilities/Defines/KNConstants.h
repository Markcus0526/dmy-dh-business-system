//
//  KNConstants.h
//  EverAfter
//
//  Created by Jianying Shi on 6/20/14.
//
//

#import <Foundation/Foundation.h>


// Constants for API
#define kBaseURL                    "http://everafter-dev.knodeit.com"

#define kAccessTokenKeyword         "?access_token="
#define kAccessToken                "0554c850-75b9-4725-b3e1-03f248e115d7"

#define kAccessTokenString          kAccessTokenKeyword""kAccessToken

#define kAPILogin                   @kBaseURL"/api/user/login"kAccessTokenString
#define kAPILogoff                  @kBaseURL"/api/user/logoff"kAccessTokenString
#define kAPIChangePassword          @kBaseURL"/api/user/change-password"kAccessTokenString
#define kAPIForgotPassword          @kBaseURL"/api/forgot-password"kAccessTokenString
#define kAPIResetBadgeNumber        @kBaseURL"/api/resetBadge"kAccessTokenString
#define kAPIResetPassword           @kBaseURL"/reset"
#define kAPIRegister                @kBaseURL"/api/user/register"kAccessTokenString
#define kAPICancelRegistration      @kBaseURL"/api/user/cancelRegistration"kAccessTokenString
#define kAPIRegisterMobile          @kBaseURL"/api/user/mobile"kAccessTokenString
#define kAPIRegisterDeviceToken     @kBaseURL"/api/user/token"kAccessTokenString
#define kAPICheckFriends            @kBaseURL"/api/mobile/bulkExistance"kAccessTokenString
#define kAPIUpdateProfile           @kBaseURL"/api/user/profile"kAccessTokenString
#define kAPIRequestPhoneVerify      @kBaseURL"/api/mobile/requestPhoneVerify"kAccessTokenString
#define kAPIVerifyPhone             @kBaseURL"/api/mobile/phoneVerification"kAccessTokenString

#define kAPIUploadFeed              @kBaseURL"/api/feed/upload"kAccessTokenString
#define kAPIRetrieveInbox           @kBaseURL"/api/user/inbox"kAccessTokenString
#define kAPIRetrieveOutbox          @kBaseURL"/api/user/outbox"kAccessTokenString
#define kAPIOpenedFeed              @kBaseURL"/api/feed/opened"kAccessTokenString
#define kAPIBlockUser               @kBaseURL"/api/friend/blockFriend"kAccessTokenString
#define kAPIUnblockUser             @kBaseURL"/api/friend/unblockFriend"kAccessTokenString
#define kAPIReceivedFeed            @kBaseURL"/api/feed/received"kAccessTokenString
#define kAPIOpenedFeed              @kBaseURL"/api/feed/opened"kAccessTokenString

#define kAPIInboxByFeed             @kBaseURL"/api/user/inboxByFeed"kAccessTokenString
#define kAPIInboxById               @kBaseURL"/api/user/inboxById"kAccessTokenString
#define kAPIOutboxByFeed            @kBaseURL"/api/user/outboxByFeed"kAccessTokenString
#define kAPIOutboxById              @kBaseURL"/api/user/outboxById"kAccessTokenString

#define kAPIGetUserInfo             @kBaseURL"/api/user/getInfo"kAccessTokenString

#define kAPIDeleteInbox             @kBaseURL"/api/inbox/remove"kAccessTokenString
#define kAPIDeleteOutbox            @kBaseURL"/api/outbox/remove"kAccessTokenString

#define kAPICheckMobiles              @kBaseURL"/api/mobile/bulkExistance"kAccessTokenString
#define kAPICheckEmails               @kBaseURL"/api/mobile/emailExistance"kAccessTokenString
#define kAPIAddressBookAccess         @kBaseURL"/api/user/addressBook"kAccessTokenString

#define kAPIApproveFriend             @kBaseURL"/api/user/approveFriend"kAccessTokenString
#define kAPIRejectFriend             @kBaseURL"/api/user/rejectFriend"kAccessTokenString


#define kAPITest                    @kBaseURL"/api/test"


#define kGoogleTrackingId           @"UA-53851491-2"
#define kFlurryKey                  @"WF2PH9VQWDFDRFN8SGFH"
#define kCrashAlyticsKey            @"f2b99f15d866e95b1ba01dd7c4cb0a6857b5bd08"

// content type
#define kContentTypeImage           @"IMAGE"
#define kContentTypeVideo           @"VIDEO"

// Messages
#define kNetworkError               @"Network connection error"
#define kRequestSuccessfullySent    @"Request for phone verification is sent successfully!"
// Constants for Register Mobile
#define kMinimumPhoneNumbers        10
#define kIncompletePhoneNumber      @"Please enter your complete phone number with country code"
#define kPhoneNumberDidNotRegister  @"Phone number did not register, please try again"

#define kReceiveResetPasswordToken  @"Received reset password token"

#define kSqliteName                 @"EverAfter.sqlite"


// User defaults
#define kItemNameKeychainPassowrd   @"EverAfterUserPassword"
#define kRememberPassword           @"Remember This User"
#define kDeviceTokenKeyname         @"devicetoken"
#define kUSAUser                    @"USA User"
#define kUserAvatarPictureFile      @"User avatar picture file path"
#define kIsRegistering              @"Is Registering"

// Notifications
//#define kFriendChanged              @"Friend Changed"
#define kFriendChangedByCoreData    @"CoreData Friend Changed"

#define kFriendShowMethodChanged    @"FriendShowMethod Changed"
#define kFriendSelectChanged        @"SelectFriendChanged"
#define kInboxItemSelected          @"Selected inbox item"
#define kLoginSuccessed             @"Login Successed"
#define kLoginFailed                @"Login Failed"
#define kReceivedMessage            @"Received Message"

#define kShouldCheckInbox           @"Should Check Inbox"

#define kStartedProcessContacts     @"Started Process contacts"
#define kEndedProcessContacts       @"Ended Process contacts"

#define kImageSent                  @"Image Sent"
#define kApplicationLoadFinished    @"Application load finished"

#define kShouldCheckReview          @"Should check review state"

#define kAllInboxChanged               @"Inbox Changed"
#define kAllOutboxChanged              @"Outbox Changed"
#define kInboxReady                 @"Inbox ready"
#define kOutboxReady                @"Outbox ready"

#define kOnClickSignOut             @"Signout clicked"

#define kFeedCountdownTimer         @"feed countdown"

#define kDeletedCommunication       @"Deleted communication"

// Splash constants
#define kDefaultTimeToLiveSplash    3.0f   // unit: seconds
#define kTimerIntervalSplash        0.5f    // unit: seconds

// Keyboard strategy constant
#define kTitleScaleKeyboardShwon    0.6f

// Send view constants
#define kMostRecentLimits           3
#define kTopActivityLimits            6

#define kAvatarSize         CGSizeMake(128,128)
#define kThumbnailWidth             (105.0)
#define kThumbnailHeight            (71.0)

// View controller storyboard IDs
#define kMainStoryboardName_iPhone              @"Main_iPhone"
#define kMainStoryboardName_iPad                @"Main_iPad"
#define kSplashControllerIdentifier             @"spalshNavController"
#define kLandingControllerIdentifier            @"landingNavController"
#define kHomeControllerIdentifier               @"homeTabbarController"
#define kSigninControllerIdentifier            @"signinNavController"

#define kDateTimeFormatWithTimezone             @"yyyy-MM-dd HH:mm:ss ZZZ"
#define kDateTimeFormat                         @"yyyy-MM-dd HH:mm:ss"
#define KJSONDateTimeFormat                     @"yyyy-MM-dd'T'HH:mm:ss.SSSz"


// Segue IDs
#define kSegueIDFromSplashToHome                            \
        @"segueFromSplashToHome"

#define kSegueIDFromSplashToSignin                         \
        @"segueFromSplashToSignin"

#define kSegueIDFromMobileRegistrationToPhoneVerify             \
        @"segueFromMobileRegistrationToPhoneVerify"

#define kSegueIDFromPhoneVerifyToHome                       \
        @"segueFromPhoneVerifyToHome"

#define kSegueIDFromMobileRegistrationToHome                    \
        @"segueFromMobileRegisterationToHome"

#define kSegueIDFromResetPasswordToSignin \
        @"segueFromResetPasswordToSignin"

#define kSegueIDFromCameraViewToCameraFXView    \
        @"segueFromCameraViewToCameraFX"

#define kSegueIDFromCameraViewToPhotoShare  \
        @"segueFromCameraViewToSharePhoto"

#define kSegueIDFromCameraFXToPhotoShare  \
        @"segueFromCameraFXToSharePhoto"

#define kSegueIDFromPhotoShareToImageView \
        @"segueFromPhotoShareToImageView"
// Message
#define kAppStoreURL    @"https://itunes.apple.com/us/app/score!-with-friends/id909739254?ls=1&mt=8"
#define kDefaultMessageBody                     @"I'm using EverAfter, a great application to share precious moments with your friends. Follow this link to download it from the appstore %@"