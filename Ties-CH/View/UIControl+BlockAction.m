//
//  Copyright (c) 2014 Wan, peng. All rights reserved.
//

#import <objc/runtime.h>
#import "UIControl+BlockAction.h"

@interface BlockActionWrapper : NSObject
@property (nonatomic, copy) void (^blockAction)(void);
- (void) invokeBlock:(id)sender;
@end

@implementation BlockActionWrapper
@synthesize blockAction;

- (void) dealloc {
    [self setBlockAction:nil];
}

- (void) invokeBlock:(id)sender {
    [self blockAction]();
}
@end

@implementation UIControl (BlockAction)

static const char * UIControlBlockAction = "unique";

- (void) addEventHandler:(void(^)(void))handler
        forControlEvents:(UIControlEvents)controlEvents {
    
    NSMutableArray * blockActions =
    objc_getAssociatedObject(self, &UIControlBlockAction);
    
    if (blockActions == nil) {
        blockActions = [NSMutableArray array];
        objc_setAssociatedObject(self, &UIControlBlockAction,
                                 blockActions, OBJC_ASSOCIATION_RETAIN);
    }
    
    BlockActionWrapper * target = [[BlockActionWrapper alloc] init];
    [target setBlockAction:handler];
    [blockActions addObject:target];
    
    [self addTarget:target action:@selector(invokeBlock:) forControlEvents:controlEvents];
    
}

@end

