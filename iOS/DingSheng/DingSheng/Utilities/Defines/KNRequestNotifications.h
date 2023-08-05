//
//  KNRequestNotifications.h
//  EverAfter
//
//  Created by Franck De Girolami on 5/14/13.
//  Copyright (c) 2013 Knodeit. All rights reserved.
//

#ifndef EverAfter_RequestNotifications_h
#define EverAfter_RequestNotifications_h

#define kSearchUserSuccessNotif @"Search Users Successfull Notification"
#define kSuccessfullRegisterationToken @"Token successfully registered"
#define kFailedRegisterationTokenNotification @"Failed registering token"
#define kSuccessfulGetAccessTokenRequestNotification @"Successfull Get Access token Notification"
#define kFailedGetAccessTokenRequestNotification @"Failed Trying to get Access token Notification"
#define kSuccessfullLoginRequestNotification @"Successfull Login Request Notification"
#define kSuccessfullResetPasswordtNotification @"Successfull Reset Password Request Notification"
#define kErrorResetPasswordNotification @"Error Reset Password Request Notification"

#define kFailedLoginRequestNotification @"Failed Trying To Login Notification"
#define kSuccessfullFBUserAuthLogin @"Successfull FB User Auth Login"
#define kFailedFBUserAuthLogin @"Failed FB User Auth Login"
#define kTwitterLoginSuccessfullNotification @"Twitter Login Success Notif"
#define kTwitterLoginFailedNotification @"Twitter Login Fail Notif"
#define kUpdateProfileRequestSuccessNotif @"Update profile Request SuccessFull Notification"
#define kUpdateProfileRequestFailedNotif @"Update profile Request Failed Notification"
#define kSpecialtiesUpdateSuccessfullNotif @"Specialties Update Successfull Notification"
#define kSpecialtiesAddSuccessfullNotif @"Specialties Add Successfull Notification"
#define kSpecialtiesRemoveSuccessfullNotif @"Specialties Remove Successfull Notification"
#define kSpecialtiesGetSuccessfullNotif @"Specialties Get Successfull Notification"
#define kSpecialtiesGetErrorNotif @"Specialties Get Error Notification"


#define kPostCommentComplete @"Post Comment Request Complete"
#define kGetCommentsReqFinished @"Get Comments Request Finished"
#define kCategoriesFetchedNotification @"Categories Fetched Notification"
#define kSuccessRegisterNotification @"Register Successfull notification"
#define kFailedRegiesterNotification @"Failed Register notification"
#define kMediaSearchRequestSuccess @"Media Search Request Success Notification"
#define kMediaSearchRequestNoDataFound @"Media Search Request No Data Found"

#define kGetCountriesSuccessNotif @"Get Countries Request Successfull Notification"
#define kGetCitiesSuccessNotif @"Get Cities Request Successfull Notification"
#define kGetLocationsSuccessNotif @"Get Locations Request Successfull Notification"

#define kNoInternetConnectionRequestFailed @"No Internet Connection Request Failed Notification"
#define kCloseInternetConnectionAlert @"Close Internet Connection Alert Notification"
#define kError401Notification @"Error 401 Notification"
#define kSpecialtiesUpdateFailedNotif @"Specialties Update Failed Notification"
#define kPhotoChunkRequestCompleteNotification @"Photo Chunk Request Completed sucessfully"
#define kPhotoChunkRequestFailedNotification @"Photo Chunk Request Failed"
#define kUploadMediaRequestCallbackComplete @"Upload Media Request Callback Complete"
#define kUploadMediaRequestCallbackFailed @"Upload Media Request Callback Failed"
#define kFBSessionStateChangedNotif @"FB Session State Changed Notif"

// refactored events
#define kMediaFeedUpdateCompleteNotification @"Media Feed Update Complete"
#define kSingleMediaUpdateCompleteNotification @"Single Media Update Complete"
#define kUserFeedUpdateCompleteNotification @"User Feed Update Complete"
#define kUserFeedFailedNotification @"User Feed Failed Notification"

#define kSingleUserUpdateCompleteNotification @"Single User Update Complete"
#define kRecentUploadsUpdateCompleteNotif @"Recent Uploads Update Complete Notification"
#define kFollowRequestCompleteNotification @"Follow Request Successfull Notification"
#define kLikeRequestCompleteNotification @"Follow Request Successfull Notification"
#define kActivityFeedUpdateCompleteNotification @"Activity Feed Update Complete"
#define kEmailSearchCompleteNotification @"Email Search Success Notification"
#define kFacebookSearchCompleteNotification @"Facebook Search Success Notification"
#define kTwitterSearchCompleteNotification @"Twitter Search Success Notification"
#define kProgressBarUpdateNotification @"Progress Bar Update Notification"


/*For Only KNFeedViewController Upload observer names*/
#define kPhotoChunkRequestCompleteNotificationUpload @"Photo Chunk Request Completed sucessfully upload"
#define kPhotoChunkRequestFailedNotificationUpload @"Photo Chunk Request Failed to upload"
#define kUploadMediaRequestCallbackCompleteUpload @"Upload Media Request Callback Complete upload"
#define kUploadMediaRequestCallbackFailedUpload @"Upload Media Request Callback Failed upload"
#define kResetDataOnLogoutCall @"Reset data on logout call."

#define KLogoutNotification @"Logout Notification call."
#define KFiltersChangedNotification @"Filters Changed Call Back."

#define KUpdateViewOnActiveNotification @"Update View On Coming From Background Call"


#define SHUTDOWN_CAMERA_IF_APP_GO_IN_BACKGROUND @"Shut down camera if app goes in background"
#define START_CAMERA_IF_APP_COME_IN_FOREGROUND @"start camera if app come back from background."
#define STOP_AND_SAVE_RECORDING @"Stop recording when it was started before the app went into the background."
#define kRESET_VALUES_ON_LOGOUT @"Reset categories loaded boolean variable on app logout."

#define KHIDE_SHARE_VIEW @"Hide share view if already displayed."
#endif
