//
//  UITableView+Extention.m
//  
//
//  Created by Paul on 7/11/15.
//
//

#import "UITableView+Extention.h"

@implementation UITableView (Extention)

- (void)reloadDataWithAnimation {

    [self reloadData];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.4;
    transition.subtype = kCATransitionFromTop;
    
    [self.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
    
}

@end
