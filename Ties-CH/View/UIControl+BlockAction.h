//
//  Copyright (c) 2014 Wan, peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BlockAction)

- (void) addEventHandler:(void(^)(void))handler
        forControlEvents:(UIControlEvents)controlEvents;

@end
