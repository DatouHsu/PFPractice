//
//  PFConstants.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/12/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFConstants.h"

@implementation PFConstants

#pragma mark - User Class

NSString *const PFUserTagLineKey = @"tagLine";

NSString *const PFUserProfileKey = @"profile";

NSString *const PFUserProfileNameKey = @"name";
NSString *const PFUserProfileFirstNameKey = @"firstName";
NSString *const PFUserProfileLocationKey = @"location";
NSString *const PFUserProfileGenderKey = @"gender";
NSString *const PFUserProfileBirthdayKey = @"birthday";
NSString *const PFUserProfilePictureURL = @"pictureURL";
NSString *const PFUserProfileRelationshipStatusKey = @"releationshipStatus";
NSString *const PFUserProfileAgeKey = @"age";


#pragma mark - Photo class

NSString *const PFPhotoClassKey = @"Photo";
NSString *const PFPhotoUserKey = @"user";
NSString *const PFPhotoPictureKey = @"image";

#pragma - mark Activity class

NSString *const PFActivityClassKey = @"Activity";
NSString *const PFActivityTypeKey = @"type";
NSString *const PFActivityFromUserKey = @"fromUser";
NSString *const PFActivityToUserKey = @"toUser";
NSString *const PFActivityPhotoKey = @"photo";
NSString *const PFActivityTypeLikeKey = @"like";
NSString *const PFActivityTypeDislikeKey = @"dislike";

#pragma mark - Settings

NSString *const PFMenEnabledKey = @"men";
NSString *const PFWomenEnabledKey = @"women";
NSString *const PFSingleEnabledKey = @"single";
NSString *const PFAgeMaxKey = @"ageMax";

@end
