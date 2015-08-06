//
//  AgreementView.m
//  Ties-CH
//
//  Created by on 6/11/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import "AgreementView.h"

@interface AgreementView ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *agreementView;

@end

@implementation AgreementView

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
    self.view.backgroundColor = ThemeColor;
    
    NSURL *rtfUrl = [[NSBundle mainBundle] URLForResource:@"Agreement" withExtension:@".html"];
    [self loadHTMLWithURL:rtfUrl];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Load HTML View

-(void)loadHTMLWithURL:(NSURL *)url {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_agreementView loadRequest:request];
    
    [[_agreementView.subviews objectAtIndex:0] setBounces:NO];
    _agreementView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _agreementView.opaque = NO;
    _agreementView.backgroundColor = [UIColor whiteColor];
}

#pragma mark -
#pragma mark WebView Delegate Method

- (void)webViewDidStartLoad:(UIWebView *)_webView {
    [appDelegate showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [appDelegate stopLoading];
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error {
    [appDelegate stopLoading];
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
