//
//  ShopHeaderCell.m
//  
//
//  Created by Paul on 8/4/15.
//
//

#import "ShopHeaderCell.h"

@implementation ShopHeaderCell

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
    
    return 240.0f;
    
}

@end
