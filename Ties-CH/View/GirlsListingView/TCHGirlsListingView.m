//
//  TCHGirlsListingView.m
//  Ties-CH
//
//  Created by  on 6/3/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import "TCHGirlsListingView.h"
#import "TCHGirlListCell.h"
#import "MNMBottomPullToRefreshManager.h"
#import "TCHTutorialScreen.h"
#import "TCHUtility.h"

@interface TCHGirlsListingView () <UITableViewDelegate, UITableViewDataSource, MNMBottomPullToRefreshManagerClient> {
    NSInteger pageNumber;
    
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    NSString *timeStamp;
}

@property (nonatomic, strong) NSMutableArray *arrPeople;
@property (nonatomic, weak) IBOutlet UITableView *girlsListTableView;
@property (nonatomic, weak) IBOutlet UIButton *messageComposerButton;
@property (nonatomic, weak) IBOutlet UIButton *wechatButton;

-(IBAction)onClickMessage:(id)sender;
-(IBAction)onClickProfile:(id)sender;
-(IBAction)onClickReply:(id)sender;
-(IBAction)shareViaWeChat:(id)sender;

@end

@implementation TCHGirlsListingView

-(void)loadView {
    
    timeStamp = TimeStamp;
    
    [self getUnreadMessagesCount];
    
    pageNumber = 1;
    _girlsListTableView.decelerationRate = UIScrollViewDecelerationRateFast;
    _girlsListTableView.pagingEnabled = YES;
    CGRect frame = _messageComposerButton.frame;
    CGRect frame_wechat = _wechatButton.frame;
    frame_wechat.origin.y = frame.origin.y+50;
    _wechatButton.frame = frame_wechat;
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:80.0f tableView:_girlsListTableView withClient:self];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchPeopleNearByFromServer];
    });
}

-(void)reloadLoadedView {
    [super reloadLoadedView];
    [_notificationBubble setTitle:appDelegate.numOfUnreadMessages forState:UIControlStateNormal];
    if ([appDelegate.numOfUnreadMessages isEqualToString:@"0"]) {
        [_notificationBubble setHidden:YES];
    } else {
        [_notificationBubble setHidden:NO];
    }
    
    [_arrPeople removeAllObjects];
    [_girlsListTableView reloadData];
    pageNumber = 1;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchPeopleNearByFromServer];
    });
}

-(NSMutableArray *)arrPeople {
    if (!_arrPeople) {
        _arrPeople = [[NSMutableArray alloc] init];
    }
    return _arrPeople;
}

-(void)showTutorial {
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"TCHTutorialScreen" bundle:[NSBundle mainBundle]];
    TCHTutorialScreen *view = (TCHTutorialScreen *)viewController.view;
    view.frame = appDelegate.window.frame;
    
    if (IS_HEIGHT_GTE_568) {
        [view loadImageWithImageName:[NSString stringWithFormat:@"scroll-4-iPhone5.png"]];
    } else {
        [view loadImageWithImageName:[NSString stringWithFormat:@"scroll-4-iPhone4.png"]];
    }
    
    [self addSubview:view];
}

#pragma mark -
#pragma mark Web service call

-(void)getUnreadMessagesCount {
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserProfile];
    NSString *uuid = profileDict[@"uuid"];
    if (!profileDict) {
        return;
    }
    NSMutableDictionary *parameters = [@{@"uuid": uuid} mutableCopy];
                                 
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [client GET:[NSString stringWithFormat:@"%@r/message/unreadCount?",API_HOME] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"ack"] lowercaseString] isEqualToString:@"success"]) {
            NSInteger count = [[responseObject objectForKey:@"object"] integerValue];
            if (count == 0) {
                _notificationBubble.hidden = YES;
            } else {
                _notificationBubble.hidden = NO;
            }
            appDelegate.numOfUnreadMessages = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"object"]];
            
            [_notificationBubble setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
        }
        [appDelegate stopLoading];
        [_girlsListTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [appDelegate stopLoading];
        [appDelegate.window makeToast:ServerConnection backgroundColor:RedColor];
    }];
}

-(void)fetchPeopleNearByFromServer {
    
    if ([self.arrPeople count] == 0) {
        _messageComposerButton.hidden = YES;
        _wechatButton.hidden = YES;
    } else {
        _messageComposerButton.hidden = NO;
        _wechatButton.hidden = NO;
    }
    
    NSDictionary *profileDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserProfile];
    
    NSString *lat = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%0.6f",appDelegate.bestEffortAtLocation.coordinate.longitude];
    NSString *interestIn = [profileDict objectForKey:@"interestIn"];
    NSString *uuid = profileDict[@"uuid"];
    if (!interestIn) {
        return;
    }
    NSMutableDictionary *parameters = [@{@"uuid": uuid,
                                 @"lat": lat,
                                 @"lng" : lng,
                                 @"interestIn" : interestIn,
                                 @"timestamp" : timeStamp,
                                 @"pageNumber" : [NSString stringWithFormat:@"%ld",(long)pageNumber],
                                 @"pageSize": @"20"} mutableCopy];
    [parameters handleNullValues];
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [appDelegate showLoading];

    [client GET:[NSString stringWithFormat:@"%@r/user/profile?",API_HOME] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"ack"] lowercaseString] isEqualToString:@"success"]) {
            NSArray *array = [responseObject objectForKey:@"list"];
            for (NSInteger i = 0; i < [array count]; i++) {
                [self.arrPeople addObject:[array objectAtIndex:i]];
            }
        }
        _girlsListTableView.pagingEnabled = YES;
        [appDelegate stopLoading];
        [_girlsListTableView reloadData];
        [pullToRefreshManager_ tableViewReloadFinished];
        
        if ([self.arrPeople count] == 0) {
            _messageComposerButton.hidden = YES;
            _wechatButton.hidden = YES;
        } else {
            _messageComposerButton.hidden = NO;
            _wechatButton.hidden = NO;
        }
        
        NSIndexPath *indexPath = [[_girlsListTableView indexPathsForVisibleRows] lastObject];
        [_girlsListTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:TCHTutorialForHome]) {
            [self showTutorial];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TCHTutorialForHome];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.arrPeople count] == 0) {
            _messageComposerButton.hidden = YES;
            _wechatButton.hidden = YES;
        } else {
            _messageComposerButton.hidden = NO;
            _wechatButton.hidden = NO;
        }
        
        _girlsListTableView.pagingEnabled = YES;
        [appDelegate stopLoading];
        [appDelegate.window makeToast:ServerConnection backgroundColor:RedColor];
        [pullToRefreshManager_ tableViewReloadFinished];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:TCHTutorialForHome]) {
            [self showTutorial];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TCHTutorialForHome];
        }
    }];
}

#pragma mark -
#pragma mark Action Events

-(IBAction)onClickMessage:(id)sender {
    TCHMainViewController *viewController = (TCHMainViewController *)[self rootViewController];
    [viewController setCurrentPage:kMessageList];
}

-(IBAction)onClickProfile:(id)sender {
    TCHMainViewController *viewController = (TCHMainViewController *)[self rootViewController];
    [viewController presentTCHUpdateProfileVC];
}

-(IBAction)onClickReply:(id)sender {
    NSString *receiver = @"";
    NSIndexPath *indexPath = [[_girlsListTableView indexPathsForVisibleRows] lastObject];
    ;
    NSDictionary *dict = [_arrPeople objectAtIndex:indexPath.row];
    receiver = [dict objectForKey:@"id"];
    
    TCHMainViewController *viewController = (TCHMainViewController *)[self rootViewController];
    [viewController presentTCHMessageComposeVC:receiver messageId:@"" isReplyMode:NO];
}

-(void)shareViaWeChat:(id)sender {
    
    NSIndexPath *indexPath = [[_girlsListTableView indexPathsForVisibleRows] lastObject];
    ;
    TCHGirlListCell *cell = (TCHGirlListCell *)[_girlsListTableView cellForRowAtIndexPath:indexPath];

    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[appDelegate previewImage:cell.imgPic.image]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(cell.imgPic.image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.text = @"本信息来自“简约”，围观请从速。";
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
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

#pragma mark -
#pragma mark Tableview Datasource Method

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrPeople count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCHGirlListCell *cell = [TCHGirlListCell dequeOrCreateInTable:tableView cellId:[NSString stringWithFormat:@"TCHGirlListCell%ld",(long)indexPath.row]];
    
    NSMutableDictionary *dict = [[_arrPeople objectAtIndex:indexPath.row] mutableCopy];
    [dict handleNullValues];
    
    [cell.thumbProgressView startAnimating];
    
    cell.imgPic.image = [UIImage new];
    cell.tagline.text = [dict objectForKey:@"tagline"];
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"pic"] ? [[dict objectForKey:@"pic"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"imgPlaceholder"];
    
    __weak TCHGirlListCell *weakCell = cell;
    
    [cell.imgPic setImageWithURLRequest:request
                       placeholderImage:placeholderImage
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    
                                    [weakCell.thumbProgressView stopAnimating];
                                    weakCell.imgPic.image = image;
                                    
                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    [weakCell.thumbProgressView stopAnimating];
                                }];

    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        CLLocationCoordinate2D theCoordinate;
        
        theCoordinate.latitude = [[NSString stringWithFormat:@"%@f",[dict objectForKey:@"lat"]] doubleValue];
        theCoordinate.longitude = [[NSString stringWithFormat:@"%@f",[dict objectForKey:@"lng"]] doubleValue];
        
        CLLocation* first = [[CLLocation alloc] initWithLatitude:theCoordinate.latitude longitude:theCoordinate.longitude];
        
        cell.distance.text = [appDelegate distanceFromTargetLocation:first];
    } else {
        cell.distance.text = @"";
    }
    
    cell.time.text = [appDelegate dateTimeDifference:[dict objectForKey:@"lastlogintimeForUI"]];
    cell.blackLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:BlackLayerOpacity];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullToRefreshManager_ tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [pullToRefreshManager_ tableViewReleased];
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    _girlsListTableView.pagingEnabled = NO;
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:1.0f];
}

#pragma mark -
#pragma mark Aux view methods

- (void)loadTable {
    pageNumber++;
    [self fetchPeopleNearByFromServer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [pullToRefreshManager_ relocatePullToRefreshView];
}

#pragma mark -
#pragma mark Tableview Delegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
