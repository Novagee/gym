//
//  ShopLocationCell.m
//  
//
//  Created by Paul on 8/4/15.
//
//

#import "ShopLocationCell.h"

@implementation ShopLocationCell

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
    
    return 44.0f;
    
}

- (IBAction)phoneButtonTouchUpInside:(id)sender {
    
    
}

@end
