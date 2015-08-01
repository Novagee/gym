//
//  SocialViewController.m
//  
//
//  Created by Paul on 8/1/15.
//
//

#import "SocialViewController.h"

#import "DCFilterCell.h"
#import "ChatCell.h"

@interface SocialViewController ()<DCFilterCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DCFilterCell *dcFilterCell;

@end

@implementation SocialViewController

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
    
    UINib *chatCellNib = [UINib nibWithNibName:[ChatCell cellIdentifier] bundle:nil];
    [_tableView registerNib:chatCellNib forCellReuseIdentifier:[ChatCell cellIdentifier]];
    
    _dcFilterCell = [[DCFilterCell alloc]initWithFilterNames:@[@"联系人", @"讨论圈", @"历史记录"]];
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
    
    ChatCell *chatCell = (ChatCell *)[self.tableView dequeueReusableCellWithIdentifier:[ChatCell cellIdentifier]];
    
    return chatCell;
    
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return [DCFilterCell cellHeight];
        
    }

    return [ChatCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

#pragma mark - DCFilter Delegate Mathod

- (void)dcFilterSwitchIndex:(NSUInteger)index {
    
    
    
}

@end
