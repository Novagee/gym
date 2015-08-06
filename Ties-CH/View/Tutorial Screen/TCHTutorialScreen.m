//
//  TCHTutorialScreen.m
//  Ties-CH
//
//  Created by Nishit Shah on 6/24/14.
//  Copyright (c) 2014 Nishit Shah. All rights reserved.
//

#import "TCHTutorialScreen.h"

@interface TCHTutorialScreen () <UIGestureRecognizerDelegate> {

}

@property (nonatomic, weak) IBOutlet UIImageView *tutorialImage;

@end

@implementation TCHTutorialScreen

-(void)loadImageWithImageName:(NSString *)imageName {

    _tutorialImage.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    _tutorialImage.image = [UIImage imageNamed:imageName];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(removeFromSuperview)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
}

@end
