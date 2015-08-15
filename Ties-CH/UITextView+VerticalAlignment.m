//
//  Copyright (c) 2014 Wan, peng. All rights reserved.
//
#import "UITextView+VerticalAlignment.h"

@implementation UITextView (VerticalAlignment)

- (void)alignToTop {
    // Get a message whenever the content size changes
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale]);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
}

- (void)disableAlginment {
    [self removeObserver:self forKeyPath:@"contentSize"];
}

@end
