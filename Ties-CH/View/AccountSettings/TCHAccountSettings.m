//
//  TCHAccountSettings.m
//  Ties-CH
//
//  Created by  on 6/4/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import "TCHAccountSettings.h"
#import "TCHUpdateProfileVC.h"
#import "TCHAppDelegate.h"
#import "TCHPrivacyViewCOntroller.h"
#import "NSString+HandleNull.h"
#import "NSMutableDictionary+Extension.h"
#import "TCHUtility.h"

@interface TCHAccountSettings () {
    NSInteger gender;
    GSIndeterminateProgressView *_progressView;
}

@property (nonatomic, weak) IBOutlet UIImageView *navigationBar;
@property (nonatomic, weak) IBOutlet UILabel *lblUserName;
@property (nonatomic, weak) IBOutlet UIImageView *imgGender;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *friendsButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet NKColorSwitch *locationSwitch;
@property (nonatomic, weak) IBOutlet NKColorSwitch *profileSwitch;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;

-(IBAction)onClickGender:(id)sender;
-(IBAction)valueChange:(id)sender;

-(IBAction)onClickSave:(id)sender;
-(IBAction)onClickProfile:(id)sender;

@end

@implementation TCHAccountSettings
@synthesize fromProfileScreen;

-(void)loadView {
    
    _lblUserName.text = [[NSUserDefaults standardUserDefaults] objectForKey:TCHUserName];
    
    if([CLLocationManager locationServicesEnabled]){

        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            _locationSwitch.on = FALSE;
        } else {
            _locationSwitch.on = TRUE;
        }
    } else {
        _locationSwitch.on = FALSE;
    }
    
    _profileSwitch.on = YES;
    _profileSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:TCHAcceptProfile] boolValue];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:TCHAccGender]) {
        gender = [[NSUserDefaults standardUserDefaults] integerForKey:TCHAccGender];
        _imgGender.image = [UIImage imageNamed:[NSString stringWithFormat:@"setting_gender_%ld",(long)gender]];
    }else{
        gender = 1;
        _imgGender.image = [UIImage imageNamed:[NSString stringWithFormat:@"setting_gender_%ld",(long)gender]];
    }
    
    if (self.fromProfileScreen) {
        _cameraButton.hidden = YES;
        _friendsButton.hidden = YES;
    }
    
    GSIndeterminateProgressView *progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(0, _navigationBar.frame.size.height,
                                                                                                              _navigationBar.frame.size.width, 2)];
    progressView.progressTintColor = ThemeColor;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:progressView];
    _progressView = progressView;
    self.nameLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:UserProfile] objectForKey:@"name"];
}

-(void)reloadLoadedView {
    [super reloadLoadedView];
}

#pragma mark -
#pragma mark Action Events

-(IBAction)onClickFriendsList:(id)sender {
    TCHMainViewController *viewController = (TCHMainViewController *)[self rootViewController];
    [viewController setCurrentPage:kFavoriteFriendsList];
}

-(IBAction)onClickProfile:(id)sender {
    TCHMainViewController *viewController = (TCHMainViewController *)[self rootViewController];
    [viewController presentTCHUpdateProfileVC];
}

-(IBAction)onClickGender:(id)sender {
    UIButton *button = (UIButton *)sender;
    gender = button.tag;
    [[NSUserDefaults standardUserDefaults] setInteger:gender forKey:TCHAccGender];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _imgGender.image = [UIImage imageNamed:[NSString stringWithFormat:@"setting_gender_%ld",(long)gender]];
}

-(IBAction)valueChange:(id)sender {
    if ([_locationSwitch isOn]) {
        
        if([CLLocationManager locationServicesEnabled]){

            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
                [appDelegate.window makeToast:@"地理位置信息已被系统关闭\n请到 设置-隐私-定位服务 重新打开" backgroundColor:RedColor];

                _locationSwitch.on = FALSE;
            }
        }
    }
}

-(IBAction)acceptProfile:(id)sender {
    if ([_profileSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:TCHAcceptProfile];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:TCHAcceptProfile];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)onClickPrivacy:(id)sender {
    
    TCHMainViewController *viewController = (TCHMainViewController *)[self rootViewController];
    
    TCHPrivacyViewController *controller = [[TCHPrivacyViewController alloc] initWithNibName:@"TCHPrivacyViewController" bundle:[NSBundle mainBundle]];
    
    [viewController presentViewController:controller animated:YES completion:nil];
    
}

-(IBAction)onClickSave:(id)sender {
    [_progressView startAnimating];
    self.userInteractionEnabled = NO;
    if (self.fromProfileScreen) {
        [self performSelector:@selector(registerUser) withObject:nil afterDelay:0.2];
    } else {
        [self performSelector:@selector(updateAccountInfo) withObject:nil afterDelay:0.2];
    }
}

#pragma mark -
#pragma mark Web service call

-(void)registerUser {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:TCHUserName];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceToken];
    NSString *lat = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.longitude];
    NSString *genderCode = [[[NSUserDefaults standardUserDefaults] objectForKey:TCHGenderCode] isEqualToString:TCHMale] ? @"M" : @"F";
    NSString *interestIn = [appDelegate codeForGender:gender];
    
    NSString *fileName = @"TCHFileName.jpg";
    NSString *imagePath = [SelfProfileImageName pathInDocumentDirectory];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    [self acceptProfile:nil];
    NSString *receiveProfile = [[NSUserDefaults standardUserDefaults] objectForKey:TCHAcceptProfile];
    
    NSMutableDictionary *parameters = [@{@"name":[NSString performHandleNUll:name placeHolder:@""],
                                 @"lat": [NSString performHandleNUll:lat placeHolder:@""],
                                 @"lng" : [NSString performHandleNUll:lng placeHolder:@""],
                                 @"gender" : [NSString performHandleNUll:genderCode placeHolder:@""],
                                 @"interestIn" : [NSString performHandleNUll:interestIn placeHolder:@""],
                                 @"width":[NSString stringWithFormat:@"%i", (int)width],
                                 @"height":[NSString stringWithFormat:@"%i", (int)height],
                                 @"deviceToken":[NSString performHandleNUll:token placeHolder:@""],
                                 @"receiveProfile":receiveProfile } mutableCopy];
    [parameters handleNullValues];
    
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client POST:[NSString stringWithFormat:@"%@r/user/signin?",API_HOME] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image){
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[[responseObject objectForKey:@"ack"] lowercaseString] isEqualToString:@"success"]) {
            
            self.fromProfileScreen = NO;
            
            NSMutableDictionary *dict = [[responseObject objectForKey:@"object"] mutableCopy];
            [dict handleNullValues];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:UserProfile];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsProfileConfigure];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_progressView stopAnimating];
            
            TCHUpdateProfileVC *viewController = (TCHUpdateProfileVC *)[self rootViewController];
            [viewController dismiss];
            
        } else {
            [appDelegate.window makeToast:ServerDBError backgroundColor:[UIColor redColor]];
        }
        [_progressView stopAnimating];
        self.userInteractionEnabled = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [appDelegate.window makeToast:ServerConnection backgroundColor:[UIColor redColor]];
        [_progressView stopAnimating];
        self.userInteractionEnabled = YES;
    }];
}

-(void)updateAccountInfo {
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserProfile];
    NSString *uuid = profileDict[@"uuid"];
    NSString *lat = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.longitude];

    NSString *tchAccGender = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:TCHAccGender]];
    NSString *genderCode = [tchAccGender isEqualToString:TCHMale] ? @"M" : [tchAccGender isEqualToString:TCHFemale] ? @"F" : @"";
    NSString *interestIn = [appDelegate codeForGender:gender];
    NSString *receiveProfile = [[NSUserDefaults standardUserDefaults] objectForKey:TCHAcceptProfile];
    
    NSMutableDictionary *parameters = [@{@"uuid": uuid,
                                 @"lat": lat,
                                 @"lng" : lng,
                                 @"gender" : genderCode,
                                 @"interestIn" : interestIn,
                                 @"receiveProfile":receiveProfile
                                 } mutableCopy];
    [parameters handleNullValues];
    
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client POST:[NSString stringWithFormat:@"%@r/user/profile/edit?",API_HOME] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[[responseObject objectForKey:@"ack"] lowercaseString] isEqualToString:@"success"]) {
                
                NSMutableDictionary *dict = [[responseObject objectForKey:@"object"] mutableCopy];
                [dict handleNullValues];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:UserProfile];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsProfileConfigure];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //TCHMainViewController *viewController = [[TCHMainViewController alloc]init];
                //appDelegate.window.rootViewController = viewController;
                TCHMainViewController *viewController = (TCHMainViewController *)[appDelegate.navigationController.viewControllers lastObject];
                [viewController reloadLoadedGirlList];
                [viewController setCurrentPage:kGirlsListingView];
                
            } else {
                [appDelegate.window makeToast:ServerDBError backgroundColor:[UIColor redColor]];
            }
            [_progressView stopAnimating];
            self.userInteractionEnabled = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [appDelegate.window makeToast:ServerConnection backgroundColor:[UIColor redColor]];
        [_progressView stopAnimating];
        self.userInteractionEnabled = YES;
    }];
}

- (UIViewController*)rootViewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
