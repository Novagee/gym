//
//  ActivityButtonCell.h
//  
//
//  Created by Paul on 8/4/15.
//
//

#import <UIKit/UIKit.h>

@class ActivityButtonCell;

@protocol ActivityButtonCellDelegate <NSObject>

- (void)activityButtonCellButtonTapped:(ActivityButtonCell *)activityButtonCell;

@end

@interface ActivityButtonCell : UITableViewCell

@property (weak, nonatomic) id<ActivityButtonCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
