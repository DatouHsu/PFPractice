//
//  PFLoginViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/9/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFLoginViewController.h"


@interface PFLoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (nonatomic, strong) NSMutableData *imageData;

@end

@implementation PFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ActivityIndicator.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
        [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)loginBottonPressed:(UIButton *)sender {
    
    self.ActivityIndicator.hidden = NO;
    [self.ActivityIndicator startAnimating];
    
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        
        [self.ActivityIndicator stopAnimating];
        self.ActivityIndicator.hidden = YES;
        
        if (!user) {
            if (!error) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log in Error" message:@"The Facebook login was canceled" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log in Error" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else {
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
        }
    }];
}

#pragma mark - Helper method


- (void)updateUserInformation
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"name,first_name,gender,birthday,location"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSDictionary *userDictionary = (NSDictionary *)result;
                 
                 //Create URL
                 NSString *facebookID = userDictionary[@"id"];
                 NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                 
                 NSLog(@"%@",userDictionary);
                 
                 NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:7];
                 
                 if (userDictionary[@"name"]) {
                     userProfile[PFUserProfileNameKey] = userDictionary[@"name"];
                 }
                 if (userDictionary[@"first_name"]) {
                     userProfile[PFUserProfileFirstNameKey] = userDictionary[@"first_name"];
                 }
                 if (userDictionary[@"location"][@"name"]) {
                     userProfile[PFUserProfileLocationKey] = userDictionary[@"location"][@"name"];
                 }
                 if (userDictionary[@"gender"]) {
                     userProfile[PFUserProfileGenderKey] = userDictionary[@"gender"];
                 }
                 if (userDictionary[@"birthday"]) {
                     userProfile[PFUserProfileBirthdayKey] = userDictionary[@"birthday"];
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateStyle:NSDateFormatterShortStyle];
                     NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                                     
                     NSDate *now = [NSDate date];
                     NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                                     
                     int age = seconds / 31536000;
                                     userProfile[PFUserProfileKey] = @(age);
                 }
                 if (userDictionary[@"relationship_status"]) {
                     userProfile[PFUserProfileRelationshipStatusKey] = userDictionary[@"relationship_status"];
                 }
                 if ([pictureURL absoluteString]) {
                     userProfile[PFUserProfilePictureURL] = [pictureURL absoluteString];
                 }
                 
                 [[PFUser currentUser] setObject:userProfile forKey:PFUserProfileKey];
                 [[PFUser currentUser] saveInBackground];
                 
                 [self requestImage];
             }
             else {
                 NSLog(@"Error in Facebook Request %@", error);
             }
             
         }];
    }
}

- (void)uploadPFFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if (!imageData) {
        NSLog(@"imageData was not found");
        return;
    }
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:PFPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:PFPhotoUserKey];
            [photo setObject:photoFile forKey:PFPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                NSLog(@"Photo save successfully");
            }];
        }
    }];
}

- (void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:PFPhotoClassKey];
    [query whereKey:PFPhotoUserKey equalTo:[PFUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (number == 0) {
            PFUser *user = [PFUser currentUser];
            
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[PFUserProfileKey][PFUserProfilePictureURL]];
            
            NSURLSession *session = [NSURLSession sharedSession];
            
            NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:profilePictureURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                UIImage *downloadedImage = nil;
                if (!error) {
                    downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                } else {
                    NSLog(@"downloadTaskWithRequest failed: %@", error);
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    UIImage *profileImage = downloadedImage;
                    [self uploadPFFileToParse:profileImage];
                });
            }];
            [downloadTask resume];
        }
    }];
}
@end
