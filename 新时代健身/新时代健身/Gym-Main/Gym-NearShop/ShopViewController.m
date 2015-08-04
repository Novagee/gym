//
//  ShopViewController.m
//  
//
//  Created by Paul on 8/1/15.
//
//

#import "ShopViewController.h"
#import "ShopDetailViewController.h"

#import "DCFilterCell.h"
#import "ShopCell.h"

@interface ShopViewController ()<UITableViewDataSource, UITableViewDelegate, DCFilterCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DCFilterCell *dcFilterCell;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerCustomCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCustomCells {
    
    UINib *chatCellNib = [UINib nibWithNibName:[ShopCell cellIdentifier] bundle:nil];
    [_tableView registerNib:chatCellNib forCellReuseIdentifier:[ShopCell cellIdentifier]];
    
    _dcFilterCell = [[DCFilterCell alloc]initWithFilterNames:@[@"全部", @"离我最近", @"商家分类"]];
    _dcFilterCell.delegate = self;
    
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return self.dcFilterCell;
        
    }
    
    ShopCell *shopCell = (ShopCell *)[self.tableView dequeueReusableCellWithIdentifier:[ShopCell cellIdentifier]];
    shopCell.starScoreView.totalScore = 5;
    shopCell.starScoreView.score = 3;
    
    return shopCell;
    
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return [DCFilterCell cellHeight];
        
    }
    
    return [ShopCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopDetailViewController *shopDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"shopDetailView"];
    
    [self.navigationController pushViewController:shopDetailViewController animated:YES];
    
}

#pragma mark - DCFilter Delegate Mathod

- (void)dcFilterSwitchIndex:(NSUInteger)index {
    
    
    
}

@end
