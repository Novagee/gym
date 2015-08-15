//
//  ActivityButtonCell.m
//  
//
//  Created by Paul on 8/4/15.
//
//

#import "ActivityButtonCell.h"

@implementation ActivityButtonCell

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

- (IBAction)activityButtonTapped:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(activityButtonCellButtonTapped:)]) {
        
        [_delegate activityButtonCellButtonTapped:self];
        
    }
    
}


@end
