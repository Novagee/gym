//
//  HomePageCell.m
//  
//
//  Created by Paul on 8/1/15.
//
//

#import "HomePageCell.h"

@implementation HomePageCell

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
    
    return 200.0f;
    
}

- (IBAction)bookingButtonTouchUpInside:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(homePageCellOrderButtonTapped:)]) {
        
        [_delegate homePageCellOrderButtonTapped:self];
        
    }
    
}

@end
