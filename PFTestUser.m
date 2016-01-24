//
//  PFTestUser.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/24/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFTestUser.h"

@implementation PFTestUser

+ (void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *profile = @{@"age" : @20, @"birthday" : @"11/22/1995", @"firstName" : @"Minion", @"gender" : @"male", @"location" : @"NewYork, USA", @"name" : @"Minion Adams"};
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                UIImage *profileImage = [UIImage imageNamed:@"test1.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        PFObject *photo = [PFObject objectWithClassName:PFPhotoClassKey];
                        [photo setObject:newUser forKey:PFPhotoUserKey];
                        [photo setObject:photoFile forKey:PFPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
                
            }];

        }
    }];
}

@end
