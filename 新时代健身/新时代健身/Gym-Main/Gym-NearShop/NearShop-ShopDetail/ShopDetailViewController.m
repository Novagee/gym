//
//  ShopDetailViewController.m
//  
//
//  Created by Paul on 8/4/15.
//
//

#import "ShopDetailViewController.h"

#import "ShopActivityCell.h"
#import "ShopHeaderCell.h"
#import "ShopLocationCell.h"

@interface ShopDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ShopDetailViewController

- (void)registerCustomCells {
    
    CGRect headerRect = {0, 0, 0, CGFLOAT_MIN};
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:headerRect];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    UINib *shopActivityNib = [UINib nibWithNibName:[ShopActivityCell cellIdentifier] bundle:nil];
    [_tableView registerNib:shopActivityNib forCellReuseIdentifier:[ShopActivityCell cellIdentifier]];
    
    UINib *shopHeaderNib = [UINib nibWithNibName:[ShopHeaderCell cellIdentifier] bundle:nil];
    [_tableView registerNib:shopHeaderNib forCellReuseIdentifier:[ShopHeaderCell cellIdentifier]];
    
    UINib *shopLocationNib = [UINib nibWithNibName:[ShopLocationCell cellIdentifier] bundle:nil];
    [_tableView registerNib:shopLocationNib forCellReuseIdentifier:[ShopLocationCell cellIdentifier]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerCustomCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    
    else {
        
        return 10;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ShopHeaderCell *shopHeaderCell = (ShopHeaderCell *)[_tableView dequeueReusableCellWithIdentifier:[ShopHeaderCell cellIdentifier]];
            
            shopHeaderCell.starScoreView.totalScore = 5;
            shopHeaderCell.starScoreView.score = 3;
            
            return shopHeaderCell;
            
        }
        else {
            
            ShopLocationCell *shopLocationCell = (ShopLocationCell *)[_tableView dequeueReusableCellWithIdentifier:[ShopLocationCell cellIdentifier]];
            
            return shopLocationCell;
            
        }
    }
    
    else {
        
        ShopActivityCell *shopActivityCell = (ShopActivityCell *)[_tableView dequeueReusableCellWithIdentifier:[ShopActivityCell cellIdentifier]];
        
        return shopActivityCell;
        
    }
    
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return [ShopHeaderCell cellHeight];
            
        }
        else {
            
            return [ShopLocationCell cellHeight];
            
        }
    }
    
    else {
        
        return [ShopActivityCell cellHeight];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)backButtonTouchUpInside:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
