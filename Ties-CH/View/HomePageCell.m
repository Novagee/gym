//
//  HomePageCell.m
//  
//
//  Created by Paul on 8/1/15.
//
//

#import "HomePageCell.h"
#import "UIImageView+AFNetworking.h"

@interface HomePageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

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

- (void)configureCell:(NSDictionary *)data {
    
    NSLog(@"Data: %@", [data class]);
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        _titleLabel.text = data[@"title"];
        _descriptionLabel.text = data[@"description"];
        [_coverView setImageWithURL:[NSURL URLWithString:data[@"pic"]]];
        
        NSLog(@"*************%@", data[@"title"]);
        
    }
    
}

- (IBAction)bookingButtonTouchUpInside:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(homePageCellOrderButtonTapped:)]) {
        
        [_delegate homePageCellOrderButtonTapped:self];
        
    }
    
}

@end
