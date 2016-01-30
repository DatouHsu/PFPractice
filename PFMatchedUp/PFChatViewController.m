//
//  PFChatViewController.m
//  PFMatchedUp
//
//  Created by Da-Tou on 1/27/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import "PFChatViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>

@interface PFChatViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;
@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation PFChatViewController

- (NSMutableArray *)chats
{
    if (!_chats){
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = self.withUser[@"profile"][@"firstName"];
    
}


@end
