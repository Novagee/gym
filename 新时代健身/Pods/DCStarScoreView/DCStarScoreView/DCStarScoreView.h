//
//  StarScoreView.h
//  Why
//
//  Created by Paul on 6/18/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#define kFillStarImage @"StarFill"
#define kEmptyStarImage @"StarEmpty"

@import UIKit;

@interface DCStarScoreView : UIControl

@property (assign, nonatomic) NSUInteger score;
@property (assign, nonatomic) NSUInteger totalScore;

@end
