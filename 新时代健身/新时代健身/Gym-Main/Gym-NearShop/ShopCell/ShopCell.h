//
//  ShopCell.h
//  
//
//  Created by Paul on 8/1/15.
//
//

#import <UIKit/UIKit.h>
#import "DCStarScoreView.h"

@interface ShopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DCStarScoreView *starScoreView;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
