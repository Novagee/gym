//
//  ShopHeaderCell.h
//  
//
//  Created by Paul on 8/4/15.
//
//

#import <UIKit/UIKit.h>

#import "DCStarScoreView.h"

@interface ShopHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DCStarScoreView *starScoreView;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
