//
//  ActivitydefaultCell.h
//  
//
//  Created by Paul on 8/4/15.
//
//

@import UIKit;

@interface ActivityDefaultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
