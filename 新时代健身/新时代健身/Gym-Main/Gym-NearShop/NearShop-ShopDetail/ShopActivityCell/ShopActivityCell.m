//
//  ShopActivityCell.m
//  
//
//  Created by Paul on 8/4/15.
//
//

#import "ShopActivityCell.h"

@implementation ShopActivityCell

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
    
    return 80.0f;
    
}

@end
