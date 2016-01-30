//
//  PFChatViewController.h
//  PFMatchedUp
//
//  Created by Da-Tou on 1/27/16.
//  Copyright © 2016 Da-Tou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFChatViewController : JSQMessagesViewController <JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) PFObject *chatRoom;

@end
