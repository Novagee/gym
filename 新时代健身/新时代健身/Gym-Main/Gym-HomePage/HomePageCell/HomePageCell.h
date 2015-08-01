//
//  HomePageCell.h
//  
//
//  Created by Paul on 8/1/15.
//
//

#import <UIKit/UIKit.h>

@class HomePageCell;

@protocol HomePageCellDelegate <NSObject>

- (void)homePageCellOrderButtonTapped:(HomePageCell *)homePageCell;

@end

@interface HomePageCell : UITableViewCell

@property (weak, nonatomic) id<HomePageCellDelegate> delegate;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
