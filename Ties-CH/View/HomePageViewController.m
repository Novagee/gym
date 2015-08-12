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

@interface HomePageViewController ()<UITableViewDataSource, UITableViewDelegate, HomePageCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerHomePageCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerHomePageCell {
    
    UINib *homePageNib = [UINib nibWithNibName:[HomePageCell cellIdentifier] bundle:nil];
    [_tableView registerNib:homePageNib forCellReuseIdentifier:[HomePageCell cellIdentifier]];
    
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomePageCell *homePageCell = (HomePageCell *)[tableView dequeueReusableCellWithIdentifier:[HomePageCell cellIdentifier]];
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

#pragma mark - HomePageCell

- (void)homePageCellOrderButtonTapped:(HomePageCell *)homePageCell {
    
    ActivityViewController *activityController = [[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
    [self presentViewController:activityController animated:YES completion:nil];
    
}

@end
