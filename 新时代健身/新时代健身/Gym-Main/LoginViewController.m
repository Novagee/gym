//
//  LoginViewController.m
//  
//
//  Created by Paul on 8/2/15.
//
//

#import "LoginViewController.h"
#import "WXApi.h"

@interface LoginViewController ()<WXApiDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weChatLoginButtonTouchUpInside:(id)sender {
    
    SendAuthReq* authRequest =[[SendAuthReq alloc] init];
    authRequest.scope = @"snsapi_userinfo";
    authRequest.state = @"123" ;
    [WXApi sendAuthReq:authRequest viewController:self delegate:self];
    
}

- (void)onResp:(BaseResp *)resp {
    
    
    
}

@end
