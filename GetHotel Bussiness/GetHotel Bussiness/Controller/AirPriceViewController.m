//
//  AirPriceViewController.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AirPriceViewController.h"
#import "HMSegmentedControl.h"
#import "AirPriceTableViewCell.h"
#import "staleTableViewCell.h"
#import "offerModel.h"
#import "staleModel.h"
@interface AirPriceViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger offerFlag;
    NSInteger staleFlag;
    NSInteger offerPageNum;
    BOOL offerLast;
    NSInteger stalePageNum;
    BOOL staleLast;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *offeringList;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *offeredList;
@property(strong,nonatomic)NSMutableArray *offerArr;
@property(strong,nonatomic)NSMutableArray *staleArr;
@property(strong,nonatomic)UIActivityIndicatorView *avi;


@property (strong,nonatomic)HMSegmentedControl *segmentedControl;
@end

@implementation AirPriceViewController

- (void)viewDidLoad {
    offerFlag=1;
    staleFlag=1;
    offerPageNum=1;
    stalePageNum=1;
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
    [self setSegment];
    [self setRefreshControl];
    [self offerInitializeData];
    _offerArr=[NSMutableArray new];
    _staleArr=[NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"航空";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //设置导航条是否被隐藏
    [self.navigationController setNavigationBarHidden:YES];
    
}

    //设置是否需要毛玻璃效果
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setSegment{
    _segmentedControl =[[HMSegmentedControl alloc]initWithSectionTitles:@[@"可报价",@"已过期"]];
    _segmentedControl.frame=CGRectMake(0, 84, UI_SCREEN_W, 40);
    _segmentedControl.selectedSegmentIndex=0;
    _segmentedControl.backgroundColor=self.headView.backgroundColor;
    _segmentedControl.selectionIndicatorHeight=4;
    _segmentedControl.selectionIndicatorColor=[UIColor lightGrayColor];
    _segmentedControl.selectionStyle=HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation=HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.titleTextAttributes=
    @{NSForegroundColorAttributeName:UIColorFromRGB(230, 230, 230),NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    _segmentedControl.selectedTitleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    __weak typeof(self) weakSelf=self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W*index, 0,UI_SCREEN_W , 200) animated:YES];
    }];
    [self.view addSubview:_segmentedControl];
}
#pragma mark -refreshControl
-(void)setRefreshControl{
    UIRefreshControl *offerRef=[UIRefreshControl new];
    [offerRef addTarget:self action:@selector(offerRef) forControlEvents:UIControlEventValueChanged];
    offerRef.tag=10001;
    [_offeringList addSubview:offerRef];
    UIRefreshControl *staleRef=[UIRefreshControl new];
    [staleRef addTarget:self action:@selector(staleRef) forControlEvents:UIControlEventValueChanged];
    staleRef.tag=10002;
    [_offeredList addSubview:staleRef];
}

-(void)offerRef{
    offerPageNum=1;
    [self offerRequest];
}
-(void)staleRef{
    stalePageNum=1;
    [self staleRequest];
}
-(void)offerInitializeData{
    _avi=[Utilities getCoverOnView:self.view];
    [self offerRequest];
    
}
-(void)staleInitializeData{
    _avi=[Utilities getCoverOnView:self.view];
    [self staleRequest];
}
#pragma mark -scrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView==_scrollView){
        NSInteger page = [self scrollCheck:scrollView];
         [_segmentedControl setSelectedSegmentIndex:page animated:YES];
}
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}


- (NSInteger)scrollCheck: (UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    if(offerFlag==1 && page==0){
        offerFlag=0;
        NSLog(@"第一次滑动来到scrollview可报价");
        [self offerInitializeData];
        
    }
    if(staleFlag==1 && page==1){
        staleFlag=0;
         NSLog(@"第一次滑动来到srollview已过期");
        [self staleInitializeData];
    }
   
    return page;
}
#pragma mark -request
-(void)offerRequest{
    NSDictionary *para=@{@"type":@1,@"pageNum":@(offerPageNum),@"pageSize":@5};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref=(UIRefreshControl *)[_offeringList viewWithTag:10001];
        [ref endRefreshing];
        NSLog(@"%@",responseObject);
        
            NSDictionary *result=responseObject[@"content"][@"Aviation_demand"];
            NSArray *list=result[@"list"];
            offerLast=[result[@"isLastPage"]boolValue];
            if(offerPageNum==1){
                [_offerArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                offerModel *offModel=[[offerModel alloc]initWithDict:dict];
                [_offerArr addObject:offModel];
            }
            [_offeringList reloadData];
     
        }
            failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
    }];
}
-(void)staleRequest{
     NSDictionary *para=@{@"type":@0,@"pageNum":@(stalePageNum),@"pageSize":@5};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref=(UIRefreshControl *)[_offeredList viewWithTag:10002];
        [ref endRefreshing];
        NSDictionary *result=responseObject[@"content"][@"Aviation_demand"];
        NSArray *list=result[@"list"];
        staleLast =[result[@"isLastPage"]boolValue];
        if(stalePageNum==1){
            [_staleArr removeAllObjects];
        }
        for(NSDictionary *dict in list){
            staleModel *stalemodel=[[staleModel alloc]initWithDict:dict];
            [_staleArr addObject:stalemodel];
        }
        [_offeredList reloadData];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
        
    }];
}
#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.f;
}
//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==_offeringList){
        return _offerArr.count;
    }
    else{
        return _staleArr.count;
    }
}
//设置每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==_offeringList){
    AirPriceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
        offerModel *offModel=_offerArr[indexPath.section];
   
        NSString *MDString=[offModel.lowtimestr substringWithRange:NSMakeRange(5, 6)];
        NSString *startString=[offModel.lowtimestr substringWithRange:NSMakeRange(5, 6)];
        
        cell.DateCityAirTicket.text=[NSString stringWithFormat:@"%@ %@",MDString,offModel.aviation_demand_title];
        cell.PriceDuring.text=[NSString stringWithFormat:@"价格区间¥:%@——%@",offModel.low_price,offModel.high_price];
        cell.TimeLabel.text=[NSString stringWithFormat:@"出发时间%@左右",startString];
        cell.seatOfCompany.text=offModel.aviation_demand_detail;
        
    return cell;
    }
    else if(tableView==_offeredList){
        staleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"offeredCell" forIndexPath:indexPath];
        staleModel *stalemodel=_staleArr[indexPath.section];
        NSString *MDString=[stalemodel.lowtimestr substringWithRange:NSMakeRange(5, 6)];
        NSString *startString=[stalemodel.lowtimestr substringWithRange:NSMakeRange(5, 6)];
        cell.DateCityAirTicket.text=[NSString stringWithFormat:@"%@ %@——%@ 机票",MDString,stalemodel.departure,stalemodel.destination];
        cell.PriceDuring.text=[NSString stringWithFormat:@"价格区间:¥%@-%@",stalemodel.lowPrice,stalemodel.highPrice];
        cell.TimeLabel.text=[NSString stringWithFormat:@"出发时间%@左右",startString];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==_offeringList){
        offerModel *offermodel=_offerArr[indexPath.section];
      
        [[StorageMgr singletonStorageMgr]removeObjectForKey:@"id"];
        [[StorageMgr singletonStorageMgr]addKey:@"id" andValue:@(offermodel.aviation_demand_id)];
      
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  
}
//细胞将要出现时的调用
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _offeringList){
        if(indexPath.section == _offerArr.count-1){
            if(!offerLast){
                offerPageNum++;
                [self offerRequest];
            }
        }
    }else{
        if(indexPath.section==_staleArr.count-1){
            if(!staleFlag){
                stalePageNum++;
                [self staleRequest];
            }
        }
    }
}
@end
