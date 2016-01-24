//
//  PFProfileViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/18/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFProfileViewController.h"

@interface PFProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@end

@implementation PFProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFFile *pictureFile = self.photo[PFPhotoPictureKey];
    [pictureFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    
    PFUser *user = self.photo[PFPhotoUserKey];
    self.locationLabel.text = user[PFUserProfileKey][PFUserProfileLocationKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[PFUserProfileKey][PFUserProfileAgeKey]];
    self.statusLabel.text = user[PFUserProfileKey][PFUserProfileRelationshipStatusKey];
    self.tagLineLabel.text = user[PFUserTagLineKey];
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

@end
