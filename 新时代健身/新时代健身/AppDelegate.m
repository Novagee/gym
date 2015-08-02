//
//  AppDelegate.m
//  新时代健身
//
//  Created by peng wan on 7/31/15.
//  Copyright (c) 2015 IDesign Network Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

static NSString *const kWeChatAppID = @"wxd930ea5d5a258f4f";
static NSString *const kWeChatSecret = @"";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WXApi registerApp:kWeChatAppID withDescription:@"Gym"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

#pragma mark - WeChat Login Stuff

#warning Because we don't have a WeChat APPID, so I temporary use the APPID that from WeChat Demo. Once we get our own APPID, change the URL Scheme in info.plist

- (void)onResp:(BaseResp *)resp {
    
    [self fetchAuthStatusCodeWithResponse:resp];
    
}

- (void)onReq:(BaseReq *)req {
    
    
}

- (void)fetchAuthStatusCodeWithResponse:(BaseResp *)response {
    
    if (response.errCode == 0) {
        
        // Success
        //
        [self fetchAccessTokenWithCode:((SendAuthResp *)response).code];
        
    }
    else if (response.errCode == -4) {
        
        // User deny
        //
        
    }
    else {
        
        // User cancel
        //
        
    }
    
}

- (void)fetchAccessTokenWithCode:(NSString *)code {
    
    NSString *accessTokenUrlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeChatAppID,kWeChatSecret,code];
    NSURL *accessTokenURL = [NSURL URLWithString:accessTokenUrlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *accessToken = [[NSString stringWithContentsOfURL:accessTokenURL encoding:NSUTF8StringEncoding error:nil]
                                dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (accessToken) {
                
                NSDictionary *accessTokenInfo = [NSJSONSerialization JSONObjectWithData:accessToken
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                
                NSLog(@"WeChat Access Token: %@", accessTokenInfo);
                
                if (accessTokenInfo[@"errcode"]) {
                    
                    // Fetch access token failed
                    //
                    
                }
                else {
                    
                    // Save the accessToken and refreshToken here
                    //
                    // code here .....
                    
                    
                    // Fetch access token success
                    //
                    [self fetchUserInfoWithAccessToken:accessTokenInfo[@"access_token"]
                                             andOpenID:accessTokenInfo[@"openid"]];
                    
                }
                
            }
            
            
        });
        
    });
        
    
}

- (void)fetchUserInfoWithAccessToken:(NSString *)accessToken andOpenID:(NSString *)openID{
    
    NSString *userInfoUrlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openID];
    
    
    NSURL *userInfoURL = [NSURL URLWithString:userInfoUrlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *userInfoData = [[NSString stringWithContentsOfURL:userInfoURL encoding:NSUTF8StringEncoding error:nil]
                               dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (userInfoData) {
                
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:userInfoData
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:nil];
                
                if (userInfo[@"errcode"]) {
                    
                    // Fetch user info failed, use the refresh accessToken
                    //
                    
                }
                else {
                    
                    // Fetch user info success
                    //
                    
                    
                }
                
            }
            
            
            
        });
        
    });
    
}

- (void)fetchAccessTokenWithRefreshToken:(NSString *)refreshToken {
    
    // Construct URL info for fetch the user's profile
    //
    NSString *accessTokenUrlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeChatAppID,refreshToken];
    
    NSURL *accessTokenURL = [NSURL URLWithString:accessTokenUrlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *accessToken = [[NSString stringWithContentsOfURL:accessTokenURL encoding:NSUTF8StringEncoding error:nil]
                               dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (accessToken) {
                
                NSDictionary *accessTokenInfo = [NSJSONSerialization JSONObjectWithData:accessToken
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:nil];
                
                NSLog(@"WeChat Access Token: %@", accessTokenInfo);
                
                if (accessTokenInfo[@"errcode"]) {
                    
                    // All token are out of date, fetch anotherToken
                    //
                    
                    
                }
                else {
                    
                    // Fetch access token success, then we continue to fetch the user info
                    //
                    [self fetchUserInfoWithAccessToken:accessTokenInfo[@"access_token"]
                                             andOpenID:accessTokenInfo[@"openid"]];
                    
                }
                
            }
            
            
        });
        
    });
    
}

@end
