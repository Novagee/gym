//
//  ActivityDetailCell.m
//  
//
//  Created by Paul on 8/3/15.
//
//

#import "ActivityDetailCell.h"

@implementation ActivityDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier {
    
    return NSStringFromClass([self class]);
    
}

+ (CGFloat)cellHeight {
    
    return 100.0f;
    
}

@end
