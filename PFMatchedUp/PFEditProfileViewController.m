//
//  PFEditProfileViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/17/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFEditProfileViewController.h"
#import "PFSettingsViewController.h"

@interface PFEditProfileViewController ()

@property (strong, nonatomic) IBOutlet UITextView *tagLineTextView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;


@end

@implementation PFEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFQuery queryWithClassName:PFPhotoClassKey];
    [query whereKey:PFPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[PFPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                self.profilePictureImageView.image = [UIImage imageWithData:data];
            }];
        }
    }];
    self.tagLineTextView.text = [[PFUser currentUser] objectForKey:PFUserTagLineKey];
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

- (IBAction)saveBarButtomItemPressed:(UIBarButtonItem *)sender {
    [[PFUser currentUser] setObject:self.tagLineTextView.text forKey:PFUserTagLineKey];
    [[PFUser currentUser] saveInBackground];
    //NSLog(@"%@", self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
