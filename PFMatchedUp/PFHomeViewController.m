//
//  PFHomeViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/17/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFHomeViewController.h"

@interface PFHomeViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;


@end

@implementation PFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)likeButtonPressed:(UIButton *)sender {
}

- (IBAction)infoButtonPressed:(UIButton *)sender {
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender {
}

- (IBAction)chatBarButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)settingsBarButtonPressed:(UIBarButtonItem *)sender {
}



@end
