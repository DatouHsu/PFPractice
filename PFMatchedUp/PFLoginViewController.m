//
//  PFLoginViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/9/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface PFLoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;

@end

@implementation PFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ActivityIndicator.hidden = YES;
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
            [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
        }
    }];
    
    
}

@end
