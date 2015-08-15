//
//  ActivityViewController.m
//  
//
//  Created by Paul on 8/3/15.
//
//

#import "ActivityViewController.h"

#import "ActivityDetailCell.h"
#import "ActivityHeaderCell.h"
#import "ActivityDefaultCell.h"
#import "ActivityButtonCell.h"

#import "FetchEventRequest.h"
#import "ApplyEventRequest.h"
#import "TCHUtility.h"

@interface ActivityViewController ()<UITableViewDataSource, UITableViewDelegate, ActivityButtonCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *dataSource;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerCustomCells];
    
    [self fetchDatas];
    
    
    
}

- (void)fetchDatas {
    
    if (!self.datas) {
        
        _datas = [[NSMutableArray alloc]init];
        
        [_datas addObjectsFromArray:@[
                                      @{
                                          @"iconName":@"ico_pos2",
                                          @"info": @"第一好健身房"
                                          },
                                      @{
                                          @"iconName":@"ico_time",
                                          @"info": @"7月28日18时"
                                          },
                                      @{
                                          @"iconName":@"ico_money",
                                          @"info": @"100元/小时"
                                          }
                                      ]];
        
    }
    
    _dataSource = [[NSMutableDictionary alloc]init];
    
    FetchEventRequest *fetchEventRequest = [[FetchEventRequest alloc]initWithEventIndex:@"1"];
    
    [fetchEventRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSLog(@"Event Index: %@", request.responseJSONObject);
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCustomCells {
    
    CGRect headerRect = {0, 0, 0, CGFLOAT_MIN};
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:headerRect];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    UINib *activityHeaderNib = [UINib nibWithNibName:[ActivityHeaderCell cellIdentifier] bundle:nil];
    [_tableView registerNib:activityHeaderNib forCellReuseIdentifier:[ActivityHeaderCell cellIdentifier]];
    
    UINib *activityDefaultNib = [UINib nibWithNibName:[ActivityDefaultCell cellIdentifier] bundle:nil];
    [_tableView registerNib:activityDefaultNib forCellReuseIdentifier:[ActivityDefaultCell cellIdentifier]];
    
    UINib *activityDetailNib = [UINib nibWithNibName:[ActivityDetailCell cellIdentifier] bundle:nil];
    [_tableView registerNib:activityDetailNib forCellReuseIdentifier:[ActivityDetailCell cellIdentifier]];
    
    UINib *activityButtonCell = [UINib nibWithNibName:[ActivityButtonCell cellIdentifier] bundle:nil];
    [_tableView registerNib:activityButtonCell forCellReuseIdentifier:[ActivityButtonCell cellIdentifier]];
    
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    }
    else if (section == 1) {
        
        return 3;
        
    }
    else {
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ActivityHeaderCell *activityHeaderCell = (ActivityHeaderCell *)[_tableView dequeueReusableCellWithIdentifier:[ActivityHeaderCell cellIdentifier]];
        
        return activityHeaderCell;
        
    }
    else if (indexPath.section == 1) {
        
        ActivityDefaultCell *activityDefaultCell = [_tableView dequeueReusableCellWithIdentifier:[ActivityDefaultCell cellIdentifier]];
        
        activityDefaultCell.iconImageView.image = [UIImage imageNamed:self.datas[indexPath.row][@"iconName"]];
        activityDefaultCell.infoLabel.text = self.datas[indexPath.row][@"info"];
        
        return activityDefaultCell;
        
    }
    else {
        
        if (indexPath.row == 0) {
            
            ActivityDetailCell *activityDetailCell = (ActivityDetailCell *)[_tableView dequeueReusableCellWithIdentifier:[ActivityDetailCell cellIdentifier]];
            
            return activityDetailCell;
            
        }
        else {
            
            ActivityButtonCell *activityButtonCell = (ActivityButtonCell *)[_tableView dequeueReusableCellWithIdentifier:[ActivityButtonCell cellIdentifier]];
            activityButtonCell.delegate = self;
            
            return activityButtonCell;
        }
        
    }
    
}

- (void)activityButtonCellButtonTapped:(ActivityButtonCell *)activityButtonCell {
    
    ApplyEventRequest *applyEventRequest = [[ApplyEventRequest alloc]initWithUDID:[TCHUtility GetUUID] mobile:self.dataSource[@"mobile"] withEventIndex:self.dataSource[@"id"]];
    
    [applyEventRequest startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
       
        NSLog(@"Raw data: %@\nRequest: %@", self.dataSource, request.requestOperation);
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
    
    NSLog(@"DataSource: %@", self.dataSource);
    
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [ActivityHeaderCell cellHeight];
        
    }
    else if (indexPath.section == 1) {
        
        return 44.0f;
        
    }
    else {
        return [ActivityDetailCell cellHeight];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

#pragma IBActions

- (IBAction)backButtonTouchUpInside:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

@end
