//
//  MoreHistoryVC.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/14.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "MoreHistoryVC.h"
#import "MoreHistoryModel.h"
#import "MoreTableViewCell.h"
#import "UserStore.h"
#import <SVProgressHUD.h>
static NSString * const MoreTableViewCellReuseIdentifier = @"MoreTableViewCellReuseIdentifier";

@interface MoreHistoryVC ()
@property (nonatomic, strong)NSMutableArray *moreHistoryArray;
@end

@implementation MoreHistoryVC
- (NSMutableArray *)moreHistoryArray{
    if (_moreHistoryArray == nil) {
        _moreHistoryArray = [NSMutableArray array];
    }
    return _moreHistoryArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = 40;
    self.title = @"开奖结果";
    self.tableView.tableFooterView = [[UIView alloc]init];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MoreTableViewCell class]) bundle:nil] forCellReuseIdentifier:MoreTableViewCellReuseIdentifier];
    [self getHistoryData];
}
- (void)getHistoryData{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UserStore sharedInstance]getHistorySucessBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = (NSArray *)responseObject;
        for (MoreHistoryModel *model in arr) {
            
            [self.moreHistoryArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*kScaleW;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat w = 38,h = 40*kScaleW;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#0ca9ec"];
    UILabel *nebrLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, w, h)];
    nebrLable.textColor = [UIColor whiteColor];
    nebrLable.text = @"期数";
    nebrLable.font = [UIFont systemFontOfSize:12*kScaleW];
    nebrLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nebrLable];
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nebrLable.frame), 0, w, h)];
    timeLable.text = @"时间";
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = [UIFont systemFontOfSize:12*kScaleW];
    timeLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:timeLable];
    UILabel *numbleLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLable.frame), 0, kScreenWidth - CGRectGetMaxX(timeLable.frame), h)];
    numbleLable.textColor = [UIColor whiteColor];
    numbleLable.text = @"开奖结果";
    numbleLable.font = [UIFont systemFontOfSize:12*kScaleW];
    numbleLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:numbleLable];
    return headerView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _moreHistoryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreTableViewCellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_moreHistoryArray.count > indexPath.row) {
        MoreHistoryModel *model = [_moreHistoryArray objectAtIndex:indexPath.row];
        [cell historyModel:model];
    }
  
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
