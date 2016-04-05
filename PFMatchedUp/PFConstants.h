//
//  PFConstants.h
//  PFMatchedUp
//
//  Created by Da-Tou on 1/12/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFConstants : NSObject
//golbal constant
//直到程式被關閉之前 以下的變數都會佔記憶體
#pragma mark - User Profile

extern NSString *const PFUserTagLineKey;//Set an immutabl pointer to a mutable string.

extern NSString *const PFUserProfileKey;
extern NSString *const PFUserProfileNameKey;
extern NSString *const PFUserProfileFirstNameKey;
extern NSString *const PFUserProfileLocationKey;
extern NSString *const PFUserProfileGenderKey;
extern NSString *const PFUserProfileBirthdayKey;
extern NSString *const PFUserProfilePictureURL;
extern NSString *const PFUserProfileRelationshipStatusKey;
extern NSString *const PFUserProfileAgeKey;

#pragma mark - Photo class

extern NSString *const PFPhotoClassKey;
extern NSString *const PFPhotoUserKey;
extern NSString *const PFPhotoPictureKey;

#pragma mark - Activity Class

extern NSString *const PFActivityClassKey;
extern NSString *const PFActivityTypeKey;
extern NSString *const PFActivityFromUserKey;
extern NSString *const PFActivityToUserKey;
extern NSString *const PFActivityPhotoKey;
extern NSString *const PFActivityTypeLikeKey;
extern NSString *const PFActivityTypeDislikeKey;

#pragma mark - Settings

extern NSString *const PFMenEnabledKey;
extern NSString *const PFWomenEnabledKey;
extern NSString *const PFSingleEnabledKey;
extern NSString *const PFAgeMaxKey;

@end
