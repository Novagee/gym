//
//  TCHUpdateProfileVC.m
//  Ties-CH
//
//  Created by  on 6/3/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import "TCHUpdateProfileVC.h"
#import "VLBCameraView.h"
#import "TCHMainViewController.h"
#import "TCHUtility.h"
#import "TCHProfileSelection.h"
#import "TCHAccountSettings.h"
#import "TCHTutorialScreen.h"

@interface TCHUpdateProfileVC () <VLBCameraViewDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate>

@property (nonatomic, weak) IBOutlet VLBCameraView* cameraView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextField *taglineTextField;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIImageView *imgPreviousProfile;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

-(IBAction)onClickClose:(id)sender;
-(IBAction)takePicture:(id)sender;

@end

@implementation TCHUpdateProfileVC

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
    
    NSString *imagePath = [SelfProfileImageName pathInDocumentDirectory];
    _imgPreviousProfile.image = [UIImage imageWithContentsOfFile:imagePath];
    
    BOOL isProfileConfigure = [[NSUserDefaults standardUserDefaults] boolForKey:IsProfileConfigure];
    
    if (!isProfileConfigure) { //If profile settings not updated on server
        _closeButton.hidden = YES;
        
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"TCHProfileSelection" bundle:[NSBundle mainBundle]];
        TCHProfileSelection *tchProfileSelection = (TCHProfileSelection *)viewController.view;
        [tchProfileSelection loadView];
        [self.view addSubview:tchProfileSelection];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    // Init image picker controller
    //
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cameraView startCameraSession];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)showTutorial {
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"TCHTutorialScreen" bundle:[NSBundle mainBundle]];
    TCHTutorialScreen *view = (TCHTutorialScreen *)viewController.view;
    view.frame = self.view.frame;
    
    if (IS_HEIGHT_GTE_568) {
        [view loadImageWithImageName:[NSString stringWithFormat:@"profile-update-iPhone5"]];
    } else {
        [view loadImageWithImageName:[NSString stringWithFormat:@"profile-update-iPhone4"]];
    }
    
    [self.view addSubview:view];
}

#pragma mark -
#pragma mark Action Events

-(void)dismiss {
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self dismissModalViewControllerAnimated:NO];
#pragma clang diagnostic pop
    }
}

-(IBAction)onClickClose:(id)sender {
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self dismissModalViewControllerAnimated:YES];
#pragma clang diagnostic pop
    }
}

- (IBAction)onClickTagline:(id)sender {
    _placeholder.text = @"";
}

-(IBAction)onHoldCamera:(id)sender {
    
//    _imgPreviousProfile.hidden = YES;
//    [self.cameraView startShowingPreview];

    
    
}

-(void)startCamera {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:TCHTutorialForProfileImage]) {
        [self showTutorial];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TCHTutorialForProfileImage];
    }
    
    [self.cameraView startCameraSession];
}

-(void)openAppPreferences {
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"TCHAccountSettings" bundle:[NSBundle mainBundle]];
    TCHAccountSettings *tchAccountSettings = (TCHAccountSettings *)viewController.view;
    tchAccountSettings.fromProfileScreen = YES;
    [tchAccountSettings loadView];
    [self.view addSubview:tchAccountSettings];
}

-(void)saveCaptureImage:(UIImage *)image {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *imagePath = [SelfProfileImageName pathInDocumentDirectory];
    
    if([fileManager fileExistsAtPath:imagePath]) {
        [fileManager removeItemAtPath:imagePath error:nil];
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath atomically:YES];
    
}

#pragma mark -
#pragma mark VLBCameraView

-(void)cameraView:(VLBCameraView*)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary*)info meta:(NSDictionary *)meta {
    
    [self saveCaptureImage:image];
    
    if ([_closeButton isHidden]) { // When User profile settings not set
        [self performSelector:@selector(openAppPreferences) withObject:nil afterDelay:1.0];
        
    } else {    // If user profile details already saved then update only profile pic
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [appDelegate showLoading];
            [self submitInfoOnServer];
        });
    }
    
}

-(IBAction)takePicture:(id)sender {
//    [self.cameraView takePicture];
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    
    // I copy this code from the origin method above
    //
    [self saveCaptureImage:originImage];
    if ([_closeButton isHidden]) { // When User profile settings not set
        [self performSelector:@selector(openAppPreferences) withObject:nil afterDelay:1.0];
        
    } else {    // If user profile details already saved then update only profile pic
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [appDelegate showLoading];
            [self submitInfoOnServer];
        });
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark Web service call

- (void)submitInfoOnServer {
    
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserProfile];
    
    NSString *lat = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.longitude];
    NSString *genderCode = [[[NSUserDefaults standardUserDefaults] objectForKey:TCHGenderCode] isEqualToString:TCHMale] ? @"M" : @"F";
    NSString *interestIn = [profileDict objectForKey:@"interestIn"];
    NSString *uuid = profileDict[@"uuid"];
    
    NSString *imagePath = [SelfProfileImageName pathInDocumentDirectory];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    NSMutableDictionary *parameters = [@{
                                         @"uuid": uuid,
                                         @"lat": lat,
                                         @"lng" : lng,
                                         @"gender" : genderCode,
                                         @"interestIn" : interestIn,
                                         @"width":[NSString stringWithFormat:@"%i", (int)width ],
                                         @"height":[NSString stringWithFormat:@"%i", (int)height],
                                         @"tagline":_taglineTextField.text} mutableCopy];
    [parameters handleNullValues];
    NSString *fileName = [NSString stringWithFormat:@"ID_%@.jpg",[profileDict objectForKey:@"id"]];
    
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client POST:[NSString stringWithFormat:@"%@r/user/profile/edit?",API_HOME] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image){
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[[responseObject objectForKey:@"ack"] lowercaseString] isEqualToString:@"success"]) {
            
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            [appDelegate.window makeToast:ProfilePicUpdated backgroundColor:GreenColor];
            
        } else {
            [appDelegate.window makeToast:ServerDBError backgroundColor:[UIColor redColor]];
        }
        [appDelegate stopLoading];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [appDelegate.window makeToast:ServerConnection backgroundColor:[UIColor redColor]];
        [appDelegate stopLoading];
        
    }];
    
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
