//
//  SecondViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/9/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PFQuery *query = [PFQuery queryWithClassName:PFPhotoClassKey];
    [query whereKey:PFPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if ([objects count] >0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[PFPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                self.profilePictureImageView.image = [UIImage imageWithData:data];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
