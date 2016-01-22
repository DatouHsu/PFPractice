//
//  PFConstants.h
//  PFMatchedUp
//
//  Created by Da-Tou on 1/12/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFConstants : NSObject

#pragma mark - User Profile

extern NSString *const PFUserTagLineKey;

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

@end
