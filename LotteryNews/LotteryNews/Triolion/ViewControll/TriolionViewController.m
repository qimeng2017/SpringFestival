//
//  TriolionViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "TriolionViewController.h"
#import "LottoryCategoryModel.h"
#import "LNLotteryCategories.h"
#import <MJRefresh/MJRefresh.h>
#import "UserStore.h"
#import "LiuXSegmentView.h"
#import "TriolionModel.h"
#import "TriolionCell.h"
#import "TriolionTopAdModel.h"
#import "LNWebViewController.h"
#import "TriolionFootCell.h"
#import "LNLottoryConfig.h"
#import "LNScrollerView.h"
#import <SVProgressHUD.h>
#import "RankListModel.h"
#import "PersonalHomePageViewController.h"
#import "LoginViewController.h"

#import "DPCustomShareView.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

#import "TriolionHeaderCell.h"

#import "StatisticalViewController.h"
#import "RoadmapViewController.h"
#import "ScrollKLineViewController.h"
#import "MoreHistoryVC.h"
static NSString *triolionCellCellWithIdentifier = @"triolionCellCellWithIdentifier";
static NSString *TriolionFootCellWithIdentifier = @"TriolionFootCellWithIdentifier";
static NSString *TriolionHeaderCellWithIdentifier = @"TriolionHeaderCellWithIdentifier";
@interface TriolionViewController ()<UITableViewDelegate,UITableViewDataSource,TriolionFootCellDelagate,LNScrollerViewDelegate,TriolionCellDelegate,DPCustomShareViewDelegate,TriolionHeaderCellDelegate>
{
    MJRefreshNormalHeader *header;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) LottoryCategoryModel *categoryModel;
@property (nonatomic, strong) LiuXSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) LNScrollerView *scrollerView;
@property (nonatomic, strong) NSMutableArray *rankListArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong)NSMutableArray *topAdArray;
@property (nonatomic, strong) TriolionModel *shareTriolionModel;
@end

@implementation TriolionViewController
- (NSMutableArray *)topAdArray{
    if (_topAdArray == nil) {
        _topAdArray = [NSMutableArray array];
    }
    return _topAdArray;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}
- (NSMutableArray *)rankListArray{
    if (_rankListArray == nil) {
        _rankListArray = [NSMutableArray array];
    }
    return _rankListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    self.kNavigationOpenTitle = YES;
    self.navigationItemTitle = @"彩大师新春版";
     [self getTopAD];
    // Do any additional setup after loading the view.
}
- (void)configUI{
    

    
    for (LottoryCategoryModel *model in [LNLotteryCategories sharedInstance].categoryArray) {
        if ([model.caipiao_name isEqualToString:@"七星彩"]) {
            _selectedIndex = 0;
            _categoryModel = model;
            [self loadNewData];
            [header beginRefreshing];
            break;
        }
    }
    _scrollerView = [[LNScrollerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _scrollerView.delegate = self;
    CGRect tableViewFrame=CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT-tabBarHeight-navigationBarHeight-statusBarHeight);
    if (_fromTriolionNewViewController) {
        tableViewFrame = CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT-tabBarHeight);
    }
    _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _scrollerView;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.rowHeight =  115;
    _tableView.estimatedRowHeight = 100;//必须设置好预估值
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TriolionCell class]) bundle:nil] forCellReuseIdentifier:triolionCellCellWithIdentifier];
    [_tableView registerClass:[TriolionFootCell class] forCellReuseIdentifier:TriolionFootCellWithIdentifier];
    [_tableView registerClass:[TriolionHeaderCell class] forCellReuseIdentifier:TriolionHeaderCellWithIdentifier];
    LottoryCategoryModel *caModel=  [LNLotteryCategories sharedInstance].currentLottoryModel;
    _categoryModel = caModel;
    
    [self refreshHeader];
    [self refreshFooter];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLotteryDataCategoryNotification:) name:kLotteryDataCategoryNotification object:nil];
    [MobClick beginLogPageView:@"TriolionViewController"];
}
#pragma mark - 数据加载
#pragma mark -- 刷新数据
- (void)refreshHeader{
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    // 马上进入刷新状态
   // [header beginRefreshing];
    
    // 设置刷新控件
    self.tableView.mj_header = header;
     self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)refreshFooter{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置文字
    [footer setTitle:@"点击或上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor  grayColor];
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = NO;
    // 设置footer
    
    self.tableView.mj_footer = footer;
}


//- (void)kLotteryDataCategoryNotification:(NSNotification *)notification{
//    id value = notification.object;
//    if ([value isKindOfClass:[LottoryCategoryModel class]]) {
//        _categoryModel = (LottoryCategoryModel *)value;
//        [self loadNewData];
//    }
//}
- (void)loadNewData{
     _currentPage = 1;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
         [self loadData:ScrollDirectionDown];
    });
     dispatch_group_async(group, queue, ^{
         if (_selectedIndex == 0) {
             [self rankList];
         }
         });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [_tableView.mj_header endRefreshing];
       
        [SVProgressHUD dismiss];
        });


   
}
- (void)loadMoreData{
    if (_selectedIndex != 0) {
        _currentPage += 1;
        [self loadData:ScrollDirectionUp];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;
    }
    
    
}
- (void)loadData:(ScrollDirection)direction{
    [SVProgressHUD showWithStatus:@"Loading..."];
    kWeakSelf(self);
    [[UserStore sharedInstance] newsCategory:_categoryModel.caipiaoid page:_currentPage sucess:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *datas = [responseObject objectForKey:@"data"];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in datas) {
                TriolionModel *model = [[TriolionModel alloc]initWithDictionary:dict error:nil];
                [arrayM addObject:model];
                
            }
            if (direction == ScrollDirectionDown) {
                weakself.dataArray = [arrayM mutableCopy];
            }else{
                [weakself.dataArray addObjectsFromArray:arrayM];
               
            }
           
            
        }else{
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            weakself.tableView.mj_footer.hidden = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           
            
            [SVProgressHUD dismissWithDelay:1];
            if (direction == ScrollDirectionDown) {
                
                [weakself.tableView.mj_header endRefreshing];
                [weakself.tableView reloadData];
            }else if(direction == ScrollDirectionUp){
                
                [weakself.tableView reloadData];
                [weakself.tableView.mj_footer endRefreshing];
                
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getTopAD{
    [[UserStore sharedInstance]topAdSucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *top_ad_arr = [responseObject objectForKey:@"top_ad"];
        if (top_ad_arr.count > 0) {
            if (self.topAdArray.count > 0) {
                [_topAdArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in top_ad_arr) {
            TriolionTopAdModel *model = [[TriolionTopAdModel alloc]initWithDictionary:dict error:nil];
            [self.topAdArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_topAdArray.count>0) {
                _scrollerView.imageArray = _topAdArray;
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)rankList{
    NSDictionary *dict = @{@"playtype":@"1039",@"caipiaoid":@"1001",@"jisu_api_id":@"11"};
    
        kWeakSelf(self);
        
        [[UserStore sharedInstance]expert_rank:dict sucess:^(NSURLSessionDataTask *task, id responseObject) {
            
            //NSLog(@"%@",responseObject);
            NSNumber *codeNum = [responseObject objectForKey:@"code"];
            NSInteger code= [codeNum integerValue];
            if (code == 1) {
                NSArray *datas = [responseObject objectForKey:@"data"];
                if (datas.count > 0) {
                    if (_rankListArray.count > 0) {
                        [_rankListArray removeAllObjects];
                    }
                }
                for (NSDictionary *dict in datas) {
                    RankListModel *model = [[RankListModel alloc]initWithDictionary:dict error:nil];
                    [weakself.rankListArray addObject:model];
                }
               
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView.mj_header endRefreshing];
                [weakself.tableView reloadData];
                [SVProgressHUD dismiss];
                
            });
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_selectedIndex == 0) {
        if (self.rankListArray.count > 0) {
            return 3;
        }else{
            return 2;
        }
    }else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else{
         return _dataArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       return 300;
    }else if(indexPath.section == 1){
        
        return 140;
    }else{
        return 300;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 35;
    }else{
        return 30;
    }
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }else if(section == 1){
        return @"推荐专家";
    }else{
        return @"资讯";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TriolionHeaderCell *HeaderCell = [tableView dequeueReusableCellWithIdentifier:TriolionHeaderCellWithIdentifier];
        HeaderCell.delegate = self;
        return HeaderCell;
    }else if (indexPath.section == 1) {
        TriolionFootCell *FootCell = [tableView dequeueReusableCellWithIdentifier:TriolionFootCellWithIdentifier];
        FootCell.delegate = self;
        FootCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.rankListArray.count > 0) {
            [FootCell reloadScrollerView:_rankListArray];
        }
        return FootCell;
    }else{
        TriolionCell *cell = [tableView dequeueReusableCellWithIdentifier:triolionCellCellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataArray.count > indexPath.row) {
            TriolionModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.triolionModel = model;
        }
        cell.delegate = self;
        return cell;
        
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count > indexPath.row&&indexPath.section == 2) {
        TriolionModel *model = [self.dataArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:model.url];
        LNWebViewController *web = [[LNWebViewController alloc]initWithURL:url];
        web.fromTrion = YES;
        web.triolionTitle = model.title;
        web.triolionDescription = model.introduction;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:NO];
    }
    
}
- (void)shareTriolionModel:(TriolionModel *)model{
    _shareTriolionModel = model;
    [self openShareView];
}
- (void)selectedImageView:(RankListModel *)model{
    NSString *userID = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    if (userID) {
        PersonalHomePageViewController *personalHomeVC = [[PersonalHomePageViewController alloc]init];
        personalHomeVC.expert_id = model.expert_id;
        personalHomeVC.nickname = model.nickname;
        personalHomeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalHomeVC animated:YES];
    }else{
        [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    }
    
}
- (void)LNScrollerViewDidClicked:(NSUInteger)index{
    TriolionTopAdModel *model = [_adArray objectAtIndex:index];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.link]];
}
- (void)click:(NSInteger)index{
    switch (index) {
        case 0:
        {
            MoreHistoryVC *moreVC = [[MoreHistoryVC alloc]init];
             [self m_pushViewController:moreVC];
        }
            break;
        case 1:{
            StatisticalViewController *statistiaclVC = [[StatisticalViewController alloc]init];
            [self m_pushViewController:statistiaclVC];
        }
            break;
        case 2:{
            //路珠分析
            RoadmapViewController *roadMapVC = [[RoadmapViewController alloc]init];
            [self m_pushViewController:roadMapVC];
        }
            break;
        case 3:{
            //走势图
            ScrollKLineViewController *srollKLinVC = [[ScrollKLineViewController alloc]init];
            [self m_pushViewController:srollKLinVC];
        }
            break;
        default:
            break;
    }
}
- (void)m_pushViewController:(UIViewController *)viewController{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"TriolionViewController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 20;//此高度为heightForHeaderInSection高度值
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark-- 分享
- (void)openShareView{
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"}
                          ];
    DPCustomShareView *shareView = [[DPCustomShareView alloc]init];
    shareView.delegate = self;
    [shareView setShareAry:shareAry];
    [shareView showShareView];
    
}
- (void)easyCustomShareViewButtonAction:(DPCustomShareView *)shareView title:(NSString *)title selectedIndex:(NSInteger)selectedIndex{
    NSLog(@"%@",title);
    switch (selectedIndex) {
        case 0:
            [self shareFriends];
            break;
        case 1:
            [self shareCircleOfFriends];
            break;
        case 2:
            
        default:
            break;
    }
}
- (void)shareFriends{
    
   
    [WXApiRequestHandler sendLinkURL:_shareTriolionModel.url TagName:nil Title:_shareTriolionModel.title Description:_shareTriolionModel.introduction ThumbImage:nil InScene:WXSceneSession];
    
}
- (void)shareCircleOfFriends{
    
    [WXApiRequestHandler sendLinkURL:_shareTriolionModel.url TagName:nil Title:_shareTriolionModel.title Description:_shareTriolionModel.introduction ThumbImage:nil InScene:WXSceneTimeline];
}

@end
