//
//  Copyright (c) 2014 Wan, peng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RingAlertViewCompletionBlock)(NSUInteger buttonIndex);

typedef NS_ENUM(NSUInteger, RingAlertViewType) {
    RingAlertViewTypeDefault = 0,
    RingAlertViewTypeYellow  = 1,
    RingAlertViewTypeGreen   = 2,
    RingAlertViewTypeRed     = 3
};

@class RingAlertView;

@protocol RingAlertViewDelegate <NSObject>

- (void)ringAlertView:(RingAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface RingAlertView : UIView

@property (nonatomic, assign) id<RingAlertViewDelegate> delegate;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) RingAlertViewType alertType;
@property (nonatomic, strong) id userInfo;

-(void) showAlertControllerWithTitle:(NSString *)title message:(NSString *)message textfieldPlaceHolder:(NSString *)textfieldPlaceHolder cancelButtonText:(NSString *)buttonText actionButtonText:(NSString *)actionButtonText type: (RingAlertViewType)alertType;

- (void)setCompletionBlock:(RingAlertViewCompletionBlock)block;
- (RingAlertViewCompletionBlock)completionBlock;
- (void)ringAlertView:(RingAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)dismissAlert;

@end
