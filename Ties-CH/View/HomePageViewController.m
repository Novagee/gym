//
//  HomePageViewController.m
//
//
//  Created by Paul on 8/1/15.
//
//

#import "HomePageViewController.h"
#import "HomePageCell.h"
#import "ActivityViewController.h"
#import "FetchEventRequest.h"

@interface HomePageViewController ()<UITableViewDataSource, UITableViewDelegate, HomePageCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerHomePageCell];
    [self fetchData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Register custom cell from nib

- (void)registerHomePageCell {
    
    UINib *homePageNib = [UINib nibWithNibName:[HomePageCell cellIdentifier] bundle:nil];
    [_tableView registerNib:homePageNib forCellReuseIdentifier:[HomePageCell cellIdentifier]];
    
}

#pragma mark - Fetch data from server

- (void)fetchData {
    
    _dataSource = [[NSMutableArray alloc]init];
    
    FetchEventRequest *fetchEventRequest = [[FetchEventRequest alloc]init];
    [fetchEventRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSLog(@"Event responde: %@", request.responseJSONObject);
        
        [_dataSource addObject:request.responseJSONObject[@"object"]];
        
        [_tableView reloadData];
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
    
    
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCell *homePageCell = (HomePageCell *)[tableView dequeueReusableCellWithIdentifier:[HomePageCell cellIdentifier]];
    
    [homePageCell configureCell:self.dataSource[indexPath.row][0]];
    
    homePageCell.delegate = self;
    
    return homePageCell;
    
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [HomePageCell cellHeight];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [HomePageCell cellHeight];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - HomePageCell Delegate

- (void)homePageCellOrderButtonTapped:(HomePageCell *)homePageCell {
    
    ActivityViewController *activityController = [[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];

    NSIndexPath *indexPath = [_tableView indexPathForCell:homePageCell];
    activityController.dataSource = self.dataSource[indexPath.row][0];
    
    [self presentViewController:activityController animated:YES completion:nil];
    
}

@end
