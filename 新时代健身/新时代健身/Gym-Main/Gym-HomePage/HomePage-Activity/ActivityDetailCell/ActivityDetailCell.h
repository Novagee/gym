//
//  ActivityDetailCell.h
//  
//
//  Created by Paul on 8/3/15.
//
//

@import UIKit;

@interface ActivityDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *detailDescription;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end
