//
//  PFHomeViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/17/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFHomeViewController.h"
#import "PFTestUser.h"
#import "PFProfileViewController.h"
#import "PFMatchViewController.h"

@interface PFHomeViewController () <PFMatchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;

@end

@implementation PFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [PFTestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:PFPhotoClassKey];
    //底下這行會只顯示非自己的使用者.
    [query whereKey:PFPhotoUserKey notEqualTo:[PFUser currentUser]];
    
    [query includeKey:PFPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        PFProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    }
    else if ([segue.identifier isEqualToString:@"homeToMatchSegue"])
    {
        PFMatchViewController *matchVC = segue.destinationViewController;
        matchVC.matchedUserImage = self.photoImageView.image;
        matchVC.delegate = self;
    }
}

#pragma mark - IBActions

- (IBAction)likeButtonPressed:(UIButton *)sender {
    [self checkLike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender {
    [self checkDislike];
}

- (IBAction)chatBarButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)settingsBarButtonPressed:(UIBarButtonItem *)sender {
}

#pragma mark - Helper Methods

- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[PFPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"%@",error);
        }];
    }
    
    //Fix like and dislike 會累計的問題.
    
    PFQuery *queryForLike = [PFQuery queryWithClassName:PFActivityClassKey];
    [queryForLike whereKey:PFActivityTypeKey equalTo:PFActivityTypeLikeKey];
    [queryForLike whereKey:PFActivityPhotoKey equalTo:self.photo];
    [queryForLike whereKey:PFActivityFromUserKey equalTo:[PFUser currentUser]];
    
    
    PFQuery *queryForDisike = [PFQuery queryWithClassName:PFActivityClassKey];
    [queryForDisike whereKey:PFActivityTypeKey equalTo:PFActivityTypeDislikeKey];
    [queryForDisike whereKey:PFActivityPhotoKey equalTo:self.photo];
    [queryForDisike whereKey:PFActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDisike]];
    [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.activities = [objects mutableCopy];
            
            if ([self.activities count] == 0) {
                self.isLikedByCurrentUser = NO;
                self.isDislikedByCurrentUser = NO;
            } else {
                PFObject *activity = self.activities[0];
                
                if ([activity[PFActivityTypeKey] isEqualToString:PFActivityTypeLikeKey]) {
                    self.isLikedByCurrentUser = YES;
                    self.isDislikedByCurrentUser = NO;
                }
                else if ([activity[PFActivityTypeKey] isEqualToString:PFActivityTypeDislikeKey]) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = YES;
                }
                else {
                    //Some other type of activity.
                }
            }
            self.likeButton.enabled = YES;
            self.dislikeButton.enabled = YES;
            self.infoButton.enabled = YES;
        }
    }];
                                    
}

- (void)updateView
{
    NSLog(@"%@", self.photo[@"user"][@"profile"]);
    self.firstnameLabel.text = self.photo[@"user"][@"profile"][@"firstName"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[@"user"][@"profile"][@"age"]];
    self.tagLineLabel.text = self.photo[@"user"][@"tagLine"];
}

- (void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    }
    else
    {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"No More User to View" message:@"Check Back Later for more People!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alertcontroller addAction:cancelAction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }
}

- (void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
    
    [likeActivity setObject:@"like" forKey:@"type"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [likeActivity setObject:self.photo forKey:@"photo"];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self checkForPhotoUserLikes];
        [self setupNextPhoto];
    }];
}

- (void)saveDislike

{
    
    PFObject *dislikeActivity = [PFObject objectWithClassName:@"Activity"];
    
    [dislikeActivity setObject:@"dislike" forKey:@"type"];
    [dislikeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [dislikeActivity setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
    [dislikeActivity setObject:self.photo forKey:@"photo"];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject: dislikeActivity];
        [self setupNextPhoto];
    }];
    
}

- (void)checkLike
{
    if (self.isLikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser) {
        for (PFObject *activity in self.activities)
        {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    } else {
        [self saveLike];
    }
}

- (void)checkDislike
{
    if (self.isDislikedByCurrentUser){
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else {
        [self saveDislike];
    }
}

- (void)checkForPhotoUserLikes
{
    PFQuery *query = [PFQuery queryWithClassName:PFActivityClassKey];
    [query whereKey:PFActivityFromUserKey equalTo:self.photo[PFPhotoUserKey]];
    [query whereKey:PFActivityToUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if ([objects count] > 0) {
            //creat chat.
            [self createChatRoom];
        }
    }];
}

- (void)createChatRoom
{
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:self.photo[PFPhotoUserKey]];
    
    //因為會有前後按like順序的問題, 所以以下是假設對方先按後我們再按的情況.
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:self.photo[PFPhotoUserKey]];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combineQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    [combineQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if ([objects count] == 0) {
            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.photo[PFPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        }
    }];
}

- (void)presentMatchesViewController

{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
    
}


@end
