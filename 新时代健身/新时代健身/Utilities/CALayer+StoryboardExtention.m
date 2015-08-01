//
//  CALayer+StoryboardExtention.m
//  Garageman
//
//  Created by Paul on 6/17/15.
//  Copyright (c) 2015 Daqula. All rights reserved.
//

#import "CALayer+StoryboardExtention.h"

@implementation CALayer (StoryboardExtention)

- (void)setLayerBorderColor:(UIColor *)layerBorderColor {
    
    self.borderColor = layerBorderColor.CGColor;
    
}

- (UIColor *)layerBorderColor {
    return self.layerBorderColor;
}

- (void)setLayerShadowColor:(UIColor *)layerShadowColor {
    
    self.shadowColor = layerShadowColor.CGColor;
    
}

- (UIColor *)layerShadowColor {
    
    return self.layerShadowColor;
    
}

@end
