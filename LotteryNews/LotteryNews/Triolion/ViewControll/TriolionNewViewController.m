//
//  TriolionNewViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "TriolionNewViewController.h"

#import "GGBannerView.h"
#import "UserStore.h"
#import "TriolionTopAdModel.h"

#import "TriolionNewCenterView.h"
#import "PPMViewController.h"
#import "LNFlowLayout.h"
#import "CenterCollectionViewCell.h"
#import "RankListModel.h"
#import "PersonalHomePageViewController.h"
#import "LoginViewController.h"

#import "TriolionCell.h"
#import "LNWebViewController.h"
#import "LNLotteryCategories.h"
#import "LottoryCategoryModel.h"
#import "DPCustomShareView.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "TriolionViewController.h"

#import "LNLottoryConfig.h"

#define collectionH 240
#define tableViewH 600
 static NSString *cellIdentifier = @"DWViewCell";
static NSString *triolionnewCellCellWithIdentifier = @"triolionnewCellCellWithIdentifier";
@interface TriolionNewViewController ()<GGBannerViewDelegate,TriolionNewCenterViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,TriolionCellDelegate,DPCustomShareViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)GGBannerView *bannerView;
@property (nonatomic, strong)NSMutableArray *topAdArray;
@property (nonatomic, strong)NSMutableArray *rankListArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TriolionModel *shareTriolionModel;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) BOOL isPage2;
@end

@implementation TriolionNewViewController
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)topAdArray{
    if (_topAdArray == nil) {
        _topAdArray = [NSMutableArray array];
    }
    return _topAdArray;
}
- (NSMutableArray *)rankListArray{
    if (_rankListArray == nil) {
        _rankListArray = [NSMutableArray array];
    }
    return _rankListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.kNavigationOpenTitle = YES;
    self.navigationItemTitle = @"彩大师新春版";
    [self setBasice];
    [self getTopAD];
    [self rankList];
    [self triolionData];
}
//适配
- (void)setBasice{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KScalwh(0));
    }];
    self.scrollView.alwaysBounceVertical=YES;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.delegate = self;
    self.viewContent=[[UIView alloc]init];
    [self.scrollView addSubview:self.viewContent];
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self createView:self.viewContent];
    if (self.viewContent.subviews.count>0){
        [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.viewContent.subviews.lastObject).offset(KScalwh(0));
        }];
    }
    
}
- (void)createView:(UIView*)contentView{
    _bannerView = [[GGBannerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [contentView addSubview:_bannerView];
    _bannerView.delegate = self;
    
    TriolionNewCenterView *centerView = [[TriolionNewCenterView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerView.frame)+10, kScreenWidth, [TriolionNewCenterView getHeight])];
    centerView.delegate = self;
    [contentView addSubview:centerView];
    
    UIView *expertView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(centerView.frame)+20, kScreenWidth, 40)];
    expertView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:expertView];
    UILabel *expertlable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
    expertlable.text = @"推荐专家";
    [expertView addSubview:expertlable];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(expertView.frame)-1.5, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor blackColor];
    line1.alpha = 0.2;
    [expertView addSubview:line1];
    
    
    LNFlowLayout *layout = [[LNFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(expertView.frame), kScreenWidth, collectionH) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [contentView addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CenterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    
    UIView *moreViewView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame)+20, kScreenWidth, 40)];
    moreViewView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:moreViewView];
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 0, 60, 40)];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreinfotion) forControlEvents:UIControlEventTouchUpInside];
    [moreViewView addSubview:moreBtn];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
    lable.text = @"资讯";
    [moreViewView addSubview:lable];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(expertView.frame)-1.5, kScreenWidth, 1)];
    line2.backgroundColor = [UIColor blackColor];
    line2.alpha = 0.3;
    [moreViewView addSubview:line2];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moreViewView.frame), kScreenWidth, tableViewH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [contentView addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TriolionCell class]) bundle:nil] forCellReuseIdentifier:triolionnewCellCellWithIdentifier];

}
- (void)getTopAD{
    [[UserStore sharedInstance]topAdSucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *top_ad_arr = [responseObject objectForKey:@"top_ad"];
        if (top_ad_arr.count > 0) {
            if (self.topAdArray.count > 0) {
                [_topAdArray removeAllObjects];
            }
        }
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSDictionary *dict in top_ad_arr) {
            TriolionTopAdModel *model = [[TriolionTopAdModel alloc]initWithDictionary:dict error:nil];
            [self.topAdArray addObject:model];
            [imageArray addObject:model.imgLink];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_topAdArray.count>0) {
                if (_topAdArray.count == 1) {
                    _bannerView.scrollEnabled = NO;
                }else{
                   _bannerView.scrollEnabled = YES;
                }
                [_bannerView configBanner:imageArray];
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
            
            [weakself.collectionView reloadData];
           
            
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark --GGBannerViewDelegate
- (void)imageView:(UIImageView *)imageView loadImageForUrl:(NSString *)url{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload];
}
- (void)bannerView:(GGBannerView *)bannerView didSelectAtIndex:(NSUInteger)index{
    
}

#pragma mark --TriolionNewCenterViewDelegate
- (void)clickLottory:(NSInteger)didSelectIndex{
    PPMViewController *pp = [[PPMViewController alloc]init];
    pp.hidesBottomBarWhenPushed = YES;
    pp.fromTriolionNewViewController = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:pp animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark cell的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rankListArray.count;
}

#pragma mark cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (_rankListArray.count > indexPath.row) {
        RankListModel *model = [_rankListArray objectAtIndex:indexPath.item];
        [cell setContentRankModel:model];
    }
    cell.backgroundColor = LRRandomColor;
    return cell;
}

#pragma mark cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth - 100, collectionH - 30 - 30);
}

#pragma mark cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RankListModel *model = [_rankListArray objectAtIndex:indexPath.row];
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
    NSLog(@"点击图片%ld",indexPath.row);
}



#pragma mark -- 资讯
- (void)triolionData{
    for (LottoryCategoryModel *model in [LNLotteryCategories sharedInstance].categoryArray) {
        if ([model.caipiao_name isEqualToString:@"七星彩"]) {
            [self loadNewData:model];
           
            break;
        }
    }
}


- (void)loadNewData:(LottoryCategoryModel *)categoryModel{
    if (self.dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    kWeakSelf(self);
    [[UserStore sharedInstance] newsCategory:categoryModel.caipiaoid page:1 sucess:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *datas = [responseObject objectForKey:@"data"];
            for (NSDictionary *dict in datas) {
                TriolionModel *model = [[TriolionModel alloc]initWithDictionary:dict error:nil];
                [weakself.dataArray addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
  return 300;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        TriolionCell *cell = [tableView dequeueReusableCellWithIdentifier:triolionnewCellCellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataArray.count > indexPath.row) {
            TriolionModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.triolionModel = model;
        }
        cell.delegate = self;
        return cell;
        
        
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count > indexPath.row) {
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
- (void)moreinfotion{
    TriolionViewController *TriolionVC = [[TriolionViewController alloc]init];
    TriolionVC.fromTriolionNewViewController = YES;
    TriolionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:TriolionVC animated:NO];
}






@end
