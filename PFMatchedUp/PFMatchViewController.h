//
//  PFMatchViewController.h
//  PFMatchedUp
//
//  Created by Da-Tou on 1/26/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFMatchViewControllerDelegate

-(void)presentMatchesViewController;

@end

@interface PFMatchViewController : UIViewController

@property (weak) id <PFMatchViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *matchedUserImage;

@end
