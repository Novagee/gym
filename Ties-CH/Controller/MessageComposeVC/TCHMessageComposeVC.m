//
//  TCHMessageComposeVC.m
//  Ties-CH
//
//  Created by  on 6/3/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import "TCHMessageComposeVC.h"
#import "VLBCameraView.h"
#import "TCHTutorialScreen.h"
#import "TCHUtility.h"
#import "DCPathButton.h"

@interface TCHMessageComposeVC () <UITextViewDelegate, VLBCameraViewDelegate, UIAlertViewDelegate> {
    UIImage *capturedImage;
}

@property (nonatomic, weak) IBOutlet VLBCameraView* cameraView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *textViewPlaceHolder;

@property (nonatomic, weak) IBOutlet UIImageView *currentDP;

//@property (nonatomic, weak) IBOutlet UIButton *btnOpenAlert;
@property (nonatomic, weak) IBOutlet UIButton *btnTakePhoto;
@property (nonatomic, weak) IBOutlet UIButton *btnClose;
@property (nonatomic, weak) IBOutlet UIButton *btnAccept;
@property (nonatomic, strong) DCPathButton *centerButton;

@property BOOL isUsingProfile;

-(IBAction)onClickClose:(id)sender;
-(IBAction)takePicture:(id)sender;


@end

@implementation TCHMessageComposeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:TCHTutorialForMessageCompose]) {
        [self showTutorial];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TCHTutorialForMessageCompose];
    }

    _centerButton = [[DCPathButton alloc] initWithCenterImage:[UIImage imageNamed:@"camera-bounce"] highlightedImage:[UIImage imageNamed:@"camera-bounc"]];
    
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"profile-bounce"]
                                                           highlightedImage:[UIImage imageNamed:@"profile-bounce"]
                                                            backgroundImage:[UIImage imageNamed:@"profile-bounce"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"profile-bounce"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"takephoto-bounce"]
                                                           highlightedImage:[UIImage imageNamed:@"takephoto-bounce"]
                                                            backgroundImage:[UIImage imageNamed:@"takephoto-bounce"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"takephoto-bounce"]];
    
    [_centerButton addPathItems:@[itemButton_1,itemButton_2]];
    _centerButton.delegate = self;
    [self.view addSubview:_centerButton];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cameraView startCameraSession];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)showTutorial {
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"TCHTutorialScreen" bundle:[NSBundle mainBundle]];
    TCHTutorialScreen *tchTutorialScreen = (TCHTutorialScreen *)viewController.view;
    tchTutorialScreen.frame = self.view.frame;
    
    if (IS_HEIGHT_GTE_568) {
        [tchTutorialScreen loadImageWithImageName:[NSString stringWithFormat:@"tutorial-message-composer-iPhone5"]];
    } else {
        [tchTutorialScreen loadImageWithImageName:[NSString stringWithFormat:@"tutorial-message-composer-iPhone4"]];
    }
    
    [self.view addSubview:tchTutorialScreen];
}

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    if (_textView.text.length == 0) {
        [appDelegate.window makeToast:PleaseTypeMessage backgroundColor:[UIColor redColor]];
        return;
    }
    if(index == 0){
        NSString *imagePath = [SelfProfileImageName pathInDocumentDirectory];
        capturedImage = [UIImage imageWithContentsOfFile:imagePath];
        _currentDP.image = capturedImage;
        _isUsingProfile = YES;
        _btnTakePhoto.hidden = YES;
        _btnAccept.hidden = NO;
        _btnClose.hidden = NO;
        _currentDP.hidden = NO;
    }
    else{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
        UIImage *img = [UIImage imageNamed:@"compose-icon"];
        [_btnTakePhoto setImage:img forState:UIControlStateNormal];
        CGRect frame = CGRectMake((screenWidth-img.size.width)/2, _btnTakePhoto.frame.origin.y, img.size.width, _btnTakePhoto.frame.size.height);
        [_btnTakePhoto setFrame:frame];
        _btnTakePhoto.hidden = NO;
    }
    _centerButton.hidden = YES;
}

#pragma mark -
#pragma mark UITextView delegate 

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *value = @"";
    if ([text isEqualToString:@""]) {
        if (textView.text.length > 0) {
            value = [textView.text substringToIndex:textView.text.length - 1];
        }
    } else if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
        
    } else {
        value = [textView.text stringByAppendingString:text];
    }
    
    if ([value isEqualToString:@""]) {
        _textViewPlaceHolder.hidden = NO;
    } else {
        _textViewPlaceHolder.hidden = YES;
    }
    
    return YES;
}

#pragma mark -
#pragma mark UIAlertView

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        
//        NSString *imagePath = [SelfProfileImageName pathInDocumentDirectory];
//        capturedImage = [UIImage imageWithContentsOfFile:imagePath];
//        _currentDP.image = capturedImage;
//        
//        _btnTakePhoto.hidden = YES;
//        _btnAccept.hidden = NO;
//        _btnClose.hidden = NO;
//        _currentDP.hidden = NO;
//    }
//    if (buttonIndex == 2){
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        CGFloat screenWidth = screenRect.size.width;
//        UIImage *img = [UIImage imageNamed:@"compose-icon"];
//        [_btnTakePhoto setImage:img forState:UIControlStateNormal];
//        CGRect frame = CGRectMake((screenWidth-img.size.width)/2, _btnTakePhoto.frame.origin.y, img.size.width, _btnTakePhoto.frame.size.height);
//        [_btnTakePhoto setFrame:frame];
//    }
}

#pragma mark -
#pragma mark Action Events

-(IBAction)onClickClose:(id)sender {
    _centerButton.hidden = NO;
    _btnTakePhoto.hidden = YES;
    [self dismiss];
}

-(IBAction)openAlert:(id)sender {
    
    if (_textView.text.length == 0) {
        [appDelegate.window makeToast:PleaseTypeMessage backgroundColor:[UIColor redColor]];
    } else {
//        _btnOpenAlert.hidden = YES;
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有图有真相" message:@"发信息要配图哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"使用头像",@"现拍一张", nil];
//        [alertView show];
    }
}

-(IBAction)onHoldCamera:(id)sender {
    if (_textView.text.length == 0) {
        [appDelegate.window makeToast:PleaseTypeMessage backgroundColor:[UIColor redColor]];
    } else {
        _textView.hidden = YES;
        [self.cameraView startShowingPreview];
    }
}

-(IBAction)takePicture:(id)sender {
    [self.view endEditing:YES];
    if (_textView.text.length > 0) {
        [self.cameraView takePicture];
    }
}

-(IBAction)onClickDelete:(id)sender {
    _btnTakePhoto.hidden = YES;
    _btnAccept.hidden = YES;
    _btnClose.hidden = YES;
//    _btnOpenAlert.hidden = NO;
    _currentDP.hidden = YES;
    _centerButton.hidden = NO;
    [self.cameraView startCameraSession];
}

-(IBAction)onClickAccept:(id)sender {
    [appDelegate showLoading];
    self.view.userInteractionEnabled = NO;
    if (_isReplyMode) {
        [self replyMessageWithImage:capturedImage];
    } else {
        [self sendMessageWithImage:capturedImage];
    }
}

-(void)dismiss {
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self dismissModalViewControllerAnimated:YES];
#pragma clang diagnostic pop
    }
}

#pragma mark -
#pragma mark VLBCameraView

-(void)cameraView:(VLBCameraView*)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary*)info meta:(NSDictionary *)meta {
    _textView.hidden = NO;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        capturedImage = image;
        
        _btnTakePhoto.hidden = YES;
        _btnAccept.hidden = NO;
        _btnClose.hidden = NO;
        
    });
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error {

}

-(void)cameraView:(VLBCameraView *)cameraView willRekatePicture:(UIImage *)image {
    
}

#pragma mark -
#pragma mark Web service call

-(void)sendMessageWithImage:(UIImage *)image {
    
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserProfile];
    NSString *uuid = profileDict[@"uuid"];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSMutableDictionary *parameters = [@{
                                 @"uuid" : uuid,
                                 @"receiver" : _receiver,
                                 @"content": _textView.text.length > 0 ? _textView.text : @"",
                                 @"timestamp" : TimeStamp,
                                 @"width":[NSString stringWithFormat:@"%i", (int)width],
                                 @"height":[NSString stringWithFormat:@"%i", (int)height]
                                 } mutableCopy];
    [parameters handleNullValues];
    NSString *fileName = [NSString stringWithFormat:@"ID_%@.jpg",[profileDict objectForKey:@"id"]];
    
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client POST:[NSString stringWithFormat:@"%@r/message/send?",API_HOME] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image&&!_isUsingProfile){
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [appDelegate stopLoading];
        self.view.userInteractionEnabled = YES;
        if ([[responseObject objectForKey:@"ack"] isEqualToString:@"Success"]) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [appDelegate.window makeToast:MessageSentSuccessfully backgroundColor:GreenColor];
            
        }else if([[responseObject objectForKey:@"ack"] isEqualToString:@"Failure"] && [[responseObject objectForKey:@"error"] isEqualToString:@"suspend"]){
            [appDelegate.window makeToast:@"您的账号已被冻结，请速与管理员联系。" backgroundColor:[UIColor redColor]];
            
        }else if([[responseObject objectForKey:@"ack"] isEqualToString:@"Failure"] && [[responseObject objectForKey:@"error"] isEqualToString:@"USER_BLOCKED"]){
            [appDelegate.window makeToast:@"对方已屏蔽您的信息" backgroundColor:[UIColor redColor]];
            [self dismiss];
            
        }else if([[responseObject objectForKey:@"ack"] isEqualToString:@"Failure"] && [[responseObject objectForKey:@"error"] isEqualToString:@"NOT_RECEIVE_PROFILE"]){
            [appDelegate.window makeToast:@"对方不接受头像信息" backgroundColor:[UIColor redColor]];
            [self dismiss];
            
        } else {
            [appDelegate.window makeToast:ServerDBError backgroundColor:[UIColor redColor]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [appDelegate.window makeToast:ServerConnection backgroundColor:[UIColor redColor]];
        self.view.userInteractionEnabled = YES;
        [appDelegate stopLoading];
    }];
    
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
}

-(void)replyMessageWithImage:(UIImage *)image {
    
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserProfile];
    NSString *uuid = profileDict[@"uuid"];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSMutableDictionary *parameters = [@{
                                 @"uuid" : uuid,
                                 @"messageId" : _messageId,
                                 @"content": _textView.text.length > 0 ? _textView.text : @"",
                                 @"width":[NSString stringWithFormat:@"%i", (int)width],
                                 @"height":[NSString stringWithFormat:@"%i", (int)height]
                                 } mutableCopy];
    [parameters handleNullValues];
   NSString *fileName = [NSString stringWithFormat:@"ID_%@.jpg",[profileDict objectForKey:@"id"]];
    
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client POST:[NSString stringWithFormat:@"%@r/message/reply?",API_HOME] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image&&!_isUsingProfile){
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [appDelegate stopLoading];
        self.view.userInteractionEnabled = YES;
        
        if ([[responseObject objectForKey:@"ack"] isEqualToString:@"Success"]) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [appDelegate.window makeToast:MessageSentSuccessfully backgroundColor:GreenColor];
            
        }else if([[responseObject objectForKey:@"ack"] isEqualToString:@"Failure"] && [[responseObject objectForKey:@"error"] isEqualToString:@"suspend"]){
            [appDelegate.window makeToast:@"您的账号已被冻结，请速与管理员联系。" backgroundColor:[UIColor redColor]];
            
        }else if([[responseObject objectForKey:@"ack"] isEqualToString:@"Failure"] && [[responseObject objectForKey:@"error"] isEqualToString:@"USER_BLOCKED"]){
            [appDelegate.window makeToast:@"对方已屏蔽您的信息" backgroundColor:[UIColor redColor]];
            [self dismiss];
            
        }else if([[responseObject objectForKey:@"ack"] isEqualToString:@"Failure"] && [[responseObject objectForKey:@"error"] isEqualToString:@"NOT_RECEIVE_PROFILE"]){
            [appDelegate.window makeToast:@"对方不接受头像信息" backgroundColor:[UIColor redColor]];
            
        } else {
            [appDelegate.window makeToast:ServerDBError backgroundColor:[UIColor redColor]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [appDelegate.window makeToast:ServerConnection backgroundColor:[UIColor redColor]];
        self.view.userInteractionEnabled = YES;
        [appDelegate stopLoading];
    }];
    
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
