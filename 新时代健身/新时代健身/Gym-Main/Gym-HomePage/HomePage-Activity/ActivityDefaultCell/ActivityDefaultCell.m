//
//  ActivitydefaultCell.m
//  
//
//  Created by Paul on 8/4/15.
//
//

#import "ActivityDefaultCell.h"

@implementation ActivityDefaultCell

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
