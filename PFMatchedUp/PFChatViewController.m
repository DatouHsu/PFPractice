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

@property (strong, nonatomic) JSQMessagesBubbleImage *bubbleImageOutgoing;
@property (strong, nonatomic) JSQMessagesBubbleImage *bubbleImageIncoming;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *items;


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
    
    _messages = [[NSMutableArray alloc] init];
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[@"user1"];
    if ([testUser1.objectId isEqual:self.currentUser.objectId]) {
        self.withUser = self.chatRoom[@"user2"];
    }
    else {
        self.withUser = self.chatRoom[@"user1"];
    }
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    _bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor grayColor]];
    _bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor greenColor]];

    self.title = self.withUser[@"profile"][@"firstName"];
    self.initialLoadComplete = NO;
    
    [self checkForNewChats];
    
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chats count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.textView.textColor = [UIColor whiteColor];
    cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return cell;
}


#pragma mark - Messages view delegate

- (void)didSendText:(NSString *)text

{
    if (text.length != 0) {
        PFObject *chat = [PFObject objectWithClassName:@"Chat"];
        [chat setObject:self.chatRoom forKey:@"chatroom"];
        [chat setObject:[PFUser currentUser] forKey:@"fromUser"];
        [chat setObject:self.withUser forKey:@"toUser"];
        [chat setObject:text forKey:@"text"];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            NSLog(@"save complete");
            [self.chats addObject:chat];
        
            [self.collectionView reloadData];
            
            //[self finishSend];
            
            [self scrollToBottomAnimated:YES];
        }];
    }
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chat[@"fromUser"];
    if ([testFromUser.objectId isEqual:currentUser.objectId])
    {
        return _bubbleImageOutgoing;
    }
    else{
        return _bubbleImageIncoming;
    }
}

#pragma mark - Messages view data source: REQUIRED

-(void) checkForNewChats
{
    int oldChatCount = (int)[self.chats count];
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:@"Chat"];
    [queryForChats whereKey:@"chatroom" equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count]){
                self.chats = [objects mutableCopy];
                [self.collectionView reloadData];
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}

@end
