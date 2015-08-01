//
//  ShopItemFilterCell.h
//  
//
//  Created by Paul on 7/9/15.
//
//

@import UIKit;

@protocol DCFilterCellDelegate <NSObject>

- (void)dcFilterSwitchIndex:(NSUInteger)index;

@end

@interface DCFilterCell : UITableViewCell

@property (weak, nonatomic) id<DCFilterCellDelegate> delegate;

- (instancetype)initWithFilterNames:(NSArray *)names;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
