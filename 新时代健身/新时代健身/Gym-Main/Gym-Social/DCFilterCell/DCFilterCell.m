//
//  ShopItemFilterCell.m
//  
//
//  Created by Paul on 7/9/15.
//
//

#import "DCFilterCell.h"

@interface DCFilterCell ()

@property (assign, nonatomic) NSUInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *filterBottoms;

@end

@implementation DCFilterCell

#pragma mark - Initialization

- (instancetype)initWithFilterNames:(NSArray *)names {
    
    if (self = [super init]) {
        
        [self configureBasicLayout];
        [self configureFilterLayoutsWithNames:names];
        
        self.selectedIndex = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

#pragma mark - Layout Stuff

- (void)configureBasicLayout {
    
    CGRect frame = {0, 0, [UIScreen mainScreen].bounds.size.width, 50};
    self.frame = frame;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
}

- (void)configureFilterLayoutsWithNames:(NSArray *)names {
    
    _filterBottoms = [[NSMutableArray alloc]init];
    
    for (NSInteger index = 0; index < names.count; index++) {
        
        UIButton *filterButton = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 1000 + index;
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            
            [button setTitle:names[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(filterButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect frame = {0, 0, self.frame.size.width/(names.count), 48};
            button.frame = frame;
            
            CGPoint center = {(index + 0.5f) * button.frame.size.width, button.center.y};
            button.center = center;
            
            button;
        });
        
        [self addSubview:filterButton];
        
        UIView *filterBottom = ({
            
            UIView *view = [[UIView alloc]init];
            
            CGRect frame = {0, 48, self.frame.size.width/(names.count), 2};
            view.frame = frame;
            
            CGPoint center = {(index + 0.5f) * view.frame.size.width, view.center.y};
            view.center = center;
            
            view;
            
        });
        
        // Add to the filterBottoms array for handing the filter value change
        //
        [_filterBottoms addObject:filterBottom];
        
        [self addSubview:filterBottom];
        
    }
    
}

#pragma mark - Filter Value Change

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    
    for (NSUInteger index = 0; index < self.filterBottoms.count; index++) {
        
        UIView *filterBottom = self.filterBottoms[index];
        
        if (index == selectedIndex) {
            
            filterBottom.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:156.0/255.0 blue:224.0/255.0 alpha:1.0f];
            
        }
        else {
            
            filterBottom.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    UIView *view = [self viewWithTag:selectedIndex + 1100];
    view.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:156.0/255.0 blue:224.0/255.0 alpha:1.0f];
    
}

- (void)filterButtonTouchUpInside:(UIButton *)sender {

    self.selectedIndex = sender.tag - 1000;
    
    if (_delegate && [_delegate respondsToSelector:@selector(dcFilterSwitchIndex:)]) {
        
        [_delegate dcFilterSwitchIndex:sender.tag - 1000];
        
    }
    
}

#pragma mark - Cell Info

+ (NSString *)cellIdentifier {
    
    return NSStringFromClass([self class]);
    
}

+ (CGFloat)cellHeight {
    
    return 50.0f;
    
}

@end
