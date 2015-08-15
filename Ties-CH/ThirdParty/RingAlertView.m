//
//  Copyright (c) 2014 Wan, peng. All rights reserved.
//

#import "RingAlertView.h"
#import "UIControl+BlockAction.h"
#import "UITextView+VerticalAlignment.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

static BOOL alertPresented = FALSE;

@interface RingAlertView ()
@property (nonatomic, assign) CGFloat messageViewWidth;
@property (nonatomic, assign) CGFloat iconViewWidth;
@property (nonatomic, assign) CGFloat iconImageWidth;
@property (nonatomic, assign) CGFloat messageWidth;
@property (nonatomic, assign) CGFloat maxMessageHeight;
@property (nonatomic, assign) CGSize  screenSize;
@property (nonatomic, assign) CGFloat alertViewDynamicHeight;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (strong, nonatomic) UIWindow *oldWindow;
@end

const CGFloat SPACE_MARGIN = 20.0f;
const CGFloat BUTTON_VIEW_HEIGHT = 45.0f;
const NSInteger ALERT_VIEW_TAG = (NSInteger)@"RingAlertView";
static char *completionBlockKey = nil;

@implementation RingAlertView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setupViewSize];
    }
    return self;
}

+(UIWindow *)sharedAlertWindow
{
    UIWindow *sharedAlertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sharedAlertWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sharedAlertWindow.opaque = NO;
    return sharedAlertWindow;
}

-(void) setupViewSize
{
    self.screenSize = [UIScreen mainScreen].bounds.size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.iconViewWidth = 0;
        self.messageViewWidth = self.screenSize.width * 0.8;
        self.messageWidth = self.messageViewWidth - 2 * SPACE_MARGIN;
        self.iconImageWidth = 0;
    } else if([[UIDevice currentDevice].systemVersion doubleValue] > 7.1) {
        self.iconViewWidth = 0;
        self.messageViewWidth = self.screenSize.width * 0.33;
        self.messageWidth = self.messageViewWidth - 2 * SPACE_MARGIN;
        self.iconImageWidth = 0;
    } else {
        self.iconViewWidth = 0;
        self.messageViewWidth = self.screenSize.height * 0.33;
        self.messageWidth = self.messageViewWidth - 2 * SPACE_MARGIN;
        self.iconImageWidth = 0;
        self.screenSize = CGSizeMake(self.screenSize.height, self.screenSize.width);
    }
    self.maxMessageHeight = self.screenSize.height * 0.15;
}

-(UIView *)rotateView:(UIView *)originalView
{
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (orientation == UIDeviceOrientationLandscapeLeft)
    {
        [originalView setTransform:CGAffineTransformMakeRotation(M_PI / 2.0)];
    } else if (orientation == UIDeviceOrientationLandscapeRight)
    {
        [originalView setTransform:CGAffineTransformMakeRotation(M_PI / -2.0)];
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        [originalView setTransform:CGAffineTransformMakeRotation(M_PI)];
    } else if (orientation == UIDeviceOrientationPortrait)
    {
        [originalView setTransform:CGAffineTransformMakeRotation(0.0)];
    }
        originalView.frame = CGRectMake(0, 0, self.screenSize.height,self.screenSize.width);
    }
    
    return originalView;
}

-(void) showAlertInView:(UIView *)view
              withTitle: (NSString *)title
                message: (NSString *)message
   textfieldPlaceHolder:(NSString *)textfieldPlaceHolder
       cancelButtonText: (NSString *)buttonText
       actionButtonText:(NSString *)actionButtonText
{
    //Setup title message textview
    UITextView *titleView = [[UITextView alloc] init];
    titleView.userInteractionEnabled = NO;

    if (title)
    {
        UIFont  *titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : titleFont}];
        CGFloat titleViewHeight = [self textViewHeightForAttributedText:titleAttributedString andWidth:self.messageWidth];
        titleView.attributedText = titleAttributedString;
        titleView.frame = CGRectMake(SPACE_MARGIN, SPACE_MARGIN/2, self.messageWidth, titleViewHeight);
        titleView.backgroundColor = [UIColor clearColor];
        self.title = title;
    }
    else
    {
        titleView.frame = CGRectMake(SPACE_MARGIN, SPACE_MARGIN/2, self.messageWidth, 0);
    }
    
    // Setup message textview
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.selectable = NO;
    textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    textView.showsVerticalScrollIndicator = YES;
    
    if (message)
    {
        UIFont  *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        NSMutableAttributedString *messageAttributedString = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : font}];
        CGFloat textViewHeight = [self textViewHeightForAttributedText:messageAttributedString andWidth:self.messageWidth];
        
        if (textViewHeight > self.maxMessageHeight)
        {
            textViewHeight = self.maxMessageHeight;
        }
        textView.attributedText = messageAttributedString;
        textView.frame = CGRectMake(SPACE_MARGIN, titleView.frame.origin.y+titleView.frame.size.height, self.messageWidth, textViewHeight);
        textView.scrollEnabled = YES;
        textView.backgroundColor = [UIColor clearColor];
        [textView setContentOffset:CGPointZero];
        self.message = message;
   
    } else
    {
        textView.frame = CGRectMake(SPACE_MARGIN, titleView.frame.origin.y+titleView.frame.size.height, self.messageWidth, 0);
    }
    
    
    //Setup Textfield
    UITextField *alertTextfield = [UITextField new];
    [alertTextfield setBorderStyle:UITextBorderStyleRoundedRect];

    if (textfieldPlaceHolder) {
        alertTextfield.frame = CGRectMake(SPACE_MARGIN, titleView.frame.size.height + textView.frame.size.height + 15, self.messageWidth, 30);
        alertTextfield.placeholder = textfieldPlaceHolder;
    } else {
        alertTextfield.frame = CGRectMake(SPACE_MARGIN, titleView.frame.size.height + textView.frame.size.height+SPACE_MARGIN, self.messageWidth, 0);
    }
    
    //Setup horizontal line separator
    UIView *horizontalSeparator = [[UIView alloc]init];
    horizontalSeparator.frame = CGRectMake(0, titleView.frame.size.height + textView.frame.size.height+SPACE_MARGIN-1 + alertTextfield.frame.size.height + 10, self.messageViewWidth, 1);
    horizontalSeparator.backgroundColor = [UIColor whiteColor];
    
    //Setup messageView
    __block UIView *messageView = [[UIView alloc]init];
    messageView.frame = CGRectMake(self.iconViewWidth, 0, self.messageViewWidth, textView.frame.size.height+titleView.frame.size.height+BUTTON_VIEW_HEIGHT + SPACE_MARGIN + alertTextfield.frame.size.height + 10);
    messageView.clipsToBounds = YES;
    messageView.backgroundColor = [UIColor whiteColor];
    [messageView addSubview:textView];
    [messageView addSubview:titleView];
    [messageView addSubview:alertTextfield];
    [messageView addSubview:horizontalSeparator];
    self.alertViewDynamicHeight = messageView.frame.size.height;
    
    //Setup alert image view
    __block UIView *alert = [[UIView alloc]init];
    alert.frame = CGRectMake(0, 0, self.iconViewWidth, messageView.frame.size.height);
    NSString * noticeImageName;
    
    if (self.alertType == RingAlertViewTypeDefault) {
        noticeImageName = @"checkmark-icon2X";
        alert.backgroundColor = [UIColor colorWithRed:71/255.0 green:160/255.0 blue:219/255.0 alpha:1];
    } else if (self.alertType == RingAlertViewTypeGreen) {
        noticeImageName = @"checkmark-icon2X";
        alert.backgroundColor = [UIColor grayColor];
    } else if(self.alertType == RingAlertViewTypeRed)
    {
        noticeImageName = @"info-icon2X";
        alert.backgroundColor = [UIColor redColor];
    }else
    {
        noticeImageName = @"info-icon2X";
        alert.backgroundColor = [UIColor yellowColor];
    }
    
    UIImageView *noticeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:noticeImageName]];
    noticeImg.frame = CGRectMake((self.iconViewWidth - self.iconImageWidth)/2, (self.iconViewWidth - self.iconImageWidth)/2, self.iconImageWidth, self.iconImageWidth);
    [alert addSubview:noticeImg];
    
    //adding to self
    self.frame = CGRectMake((self.screenSize.width-self.messageViewWidth -self.iconViewWidth)/2, self.screenSize.height, self.iconViewWidth + self.messageViewWidth, messageView.frame.size.height);
    [self addSubview:messageView];
//    [self addSubview:alert];
    
    //Setup backgroundView
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    backgroundView.tag = ALERT_VIEW_TAG;
    backgroundView.frame = view.frame;
    [backgroundView addSubview:self];
    [self rotateView:backgroundView];
    [view addSubview:backgroundView];
    [view bringSubviewToFront:backgroundView];
    __weak __typeof(&*self)weakSelf = self;

    //Setup buttons
    if (!actionButtonText) {
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:160/255.0 blue:219/255.0 alpha:1]];
        actionBtn.frame = CGRectMake(0, textView.frame.size.height+titleView.frame.size.height + SPACE_MARGIN + alertTextfield.frame.size.height + 10, self.messageViewWidth, BUTTON_VIEW_HEIGHT);
        [actionBtn setTitle:buttonText forState:UIControlStateNormal];
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [actionBtn addEventHandler:^{
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            [strongSelf ringAlertView:strongSelf clickedButtonAtIndex:0];
            [strongSelf popDownAlertView];
        } forControlEvents:UIControlEventTouchUpInside];
        [messageView addSubview:actionBtn];
    } else {
        UIView *verticalSeparator = [[UIView alloc]init];
             verticalSeparator.frame = CGRectMake(self.messageViewWidth/2-1, textView.frame.size.height+titleView.frame.size.height + SPACE_MARGIN + alertTextfield.frame.size.height + 10, 1, BUTTON_VIEW_HEIGHT);
        verticalSeparator.backgroundColor = [UIColor whiteColor];
        [messageView addSubview:verticalSeparator];

        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:160/255.0 blue:219/255.0 alpha:1]];
        [actionBtn setTitle:actionButtonText forState:UIControlStateNormal];
        actionBtn.frame = CGRectMake(self.messageViewWidth/2, textView.frame.size.height+titleView.frame.size.height + SPACE_MARGIN + alertTextfield.frame.size.height + 10, self.messageViewWidth/2, BUTTON_VIEW_HEIGHT);
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [actionBtn addEventHandler:^{
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            [strongSelf ringAlertView:strongSelf clickedButtonAtIndex:1];
            [strongSelf popDownAlertView];
        } forControlEvents:UIControlEventTouchUpInside];
        [messageView addSubview:actionBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:160/255.0 blue:219/255.0 alpha:1]];
        cancelBtn.frame = CGRectMake(0, textView.frame.size.height+titleView.frame.size.height + SPACE_MARGIN + alertTextfield.frame.size.height + 10, self.messageViewWidth/2-1, BUTTON_VIEW_HEIGHT);
        [cancelBtn setTitle:buttonText forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addEventHandler:^{
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            [strongSelf ringAlertView:strongSelf clickedButtonAtIndex:0];
            [strongSelf popDownAlertView];
        } forControlEvents:UIControlEventTouchUpInside];
        [messageView addSubview:cancelBtn];
    }
    //Animation
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10.0
                        options:0
                     animations:^{
                         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
                         
                         strongSelf.frame = CGRectMake((strongSelf.screenSize.width-strongSelf.messageViewWidth -strongSelf.iconViewWidth)/2, strongSelf.screenSize.height/2 - strongSelf.frame.size.height/2, strongSelf.iconViewWidth + strongSelf.messageViewWidth, strongSelf.alertViewDynamicHeight);
                     }
                     completion:nil];

}

- (void)dismissAlert
{
    UIView * alert = [self.alertWindow viewWithTag:ALERT_VIEW_TAG];
    if (alert) {
        [alert removeFromSuperview];
    }
    
    [self.alertWindow setHidden:YES];
    [self.alertWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.alertWindow removeFromSuperview];
    self.alertWindow.rootViewController = nil;
    self.alertWindow = nil;
    [self.oldWindow makeKeyAndVisible];
    [self.oldWindow setHidden:NO];
    alertPresented = FALSE;
}

-(void)popDownAlertView
{
    __weak __typeof(&*self) weakSelf = self;

    [UIView animateWithDuration:0.13
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
                         strongSelf.frame = CGRectMake((strongSelf.screenSize.width-strongSelf.messageViewWidth -strongSelf.iconViewWidth)/2, strongSelf.screenSize.height/2 - strongSelf.frame.size.height/2 - SPACE_MARGIN * 2, strongSelf.iconViewWidth + strongSelf.messageViewWidth, strongSelf.alertViewDynamicHeight);
                     }
                     completion:^(BOOL finished){
                         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
                         [UIView animateWithDuration:0.26
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              strongSelf.frame = CGRectMake((strongSelf.screenSize.width-strongSelf.messageViewWidth -strongSelf.iconViewWidth)/2,
                                                                            strongSelf.screenSize.height,
                                                                            strongSelf.iconViewWidth + strongSelf.messageViewWidth,
                                                                            strongSelf.alertViewDynamicHeight);
                                          } completion:^(BOOL finished) {
                                              [strongSelf dismissAlert];
                                          }];
                     }];
    
}

-(void) showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                textfieldPlaceHolder:(NSString *)textfieldPlaceHolder                    cancelButtonText:(NSString *)buttonText
                    actionButtonText:(NSString *)actionButtonText
{
    if (!alertPresented)
    {
        self.oldWindow = [AppDelegate sharedInstance].window;
        self.alertWindow = [RingAlertView sharedAlertWindow];
        self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
                
        if ([[NSThread currentThread] isMainThread]) {
            
            [self showAlertInView:self.alertWindow withTitle:title message:message textfieldPlaceHolder:textfieldPlaceHolder cancelButtonText:buttonText actionButtonText:actionButtonText];
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                [self showAlertInView:self.alertWindow withTitle:title message:message textfieldPlaceHolder:textfieldPlaceHolder cancelButtonText:buttonText actionButtonText:actionButtonText];
            });
        }
        
        [self.alertWindow makeKeyAndVisible];
        alertPresented = YES;
    }
}

-(void) showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                textfieldPlaceHolder:(NSString *)textfieldPlaceHolder cancelButtonText:(NSString *)buttonText
                    actionButtonText:(NSString *)actionButtonText
                                type: (RingAlertViewType)alertType
{
    self.alertType = alertType;
    [self showAlertControllerWithTitle:title message:message textfieldPlaceHolder:textfieldPlaceHolder cancelButtonText:buttonText actionButtonText:actionButtonText];
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text
                                  andWidth:(CGFloat)width
{
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

#pragma mark - RingAlertView Delegate methods
- (void)ringAlertView:(RingAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    RingAlertViewCompletionBlock block = [self completionBlock];
    
    if (block)
    {
        block(buttonIndex);
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(ringAlertView:clickedButtonAtIndex:)])
    {
        [self.delegate ringAlertView:alertView clickedButtonAtIndex:buttonIndex];
        return;
    }
}

#pragma mark - Completion block
- (void)setCompletionBlock:(RingAlertViewCompletionBlock)block
{
    objc_setAssociatedObject(self, &completionBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (RingAlertViewCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, &completionBlockKey);
}

- (void)dealloc
{
    self.delegate = nil;
    _userInfo = nil;
}

@end
