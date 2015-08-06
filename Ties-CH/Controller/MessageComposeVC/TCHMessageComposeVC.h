//
//  TCHMessageComposeVC.h
//  Ties-CH
//
//  Created by  on 6/3/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCPathButton.h"

@interface TCHMessageComposeVC : UIViewController<DCPathButtonDelegate>

@property (nonatomic, assign) NSString *receiver;
@property (nonatomic, assign) NSString *messageId;
@property (nonatomic, assign) BOOL isReplyMode;

@end
