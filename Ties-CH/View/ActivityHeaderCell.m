//
//  ActivityHeaderCell.m
//  
//
//  Created by Paul on 8/3/15.
//
//

#import "ActivityHeaderCell.h"

@interface ActivityHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ActivityHeaderCell

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
    
    return 210.0f;
    
}

@end
