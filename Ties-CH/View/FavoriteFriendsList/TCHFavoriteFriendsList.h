//
//  TCHFavoriteFriendsList.h
//  Ties-CH
//
//  Created by  on 6/3/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMContactsSelector.h"
#import <MessageUI/MessageUI.h>

@interface TCHFavoriteFriendsList : TCHRootView <SMContactsSelectorDelegate, MFMessageComposeViewControllerDelegate>

-(void)loadView;

@end
