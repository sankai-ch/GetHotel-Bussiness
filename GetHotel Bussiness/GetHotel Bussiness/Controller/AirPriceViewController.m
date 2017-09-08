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
#import "OfferModel.h"
@interface AirPriceViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger offerFlag;
    NSInteger staleFlag;
    NSInteger offerPageNum;
    BOOL offerLast;
    NSInteger statlePageNum;
    BOOL statleLast;
    NSInteger pageSize;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *offeringList;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *offeredList;
@property (strong,nonatomic) NSMutableArray *offerArr;

@property (strong,nonatomic)HMSegmentedControl *segmentedControl;
@end

@implementation AirPriceViewController

- (void)viewDidLoad {
    offerFlag=1;
    staleFlag=1;
    offerPageNum=1;
    statlePageNum=1;
    pageSize=5;
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
    [self setSegment];
    [self OfferRequest];
    _offerArr=[NSMutableArray new];
   
    
    
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
        
    }
    if(staleFlag==1 && page==1){
        staleFlag=0;
         NSLog(@"第一次滑动来到srollview已过期");
    }
   
    return page;
}
#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.f;
}
//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return _offerArr.count;
}
//设置每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==_offeringList){
    AirPriceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
        OfferModel *offerModel=_offerArr[indexPath.section];
        cell.DateCityAirTicket.text=offerModel.aviationdemandtitle;
        NSInteger dateInTime=[offerModel.startime integerValue];
        NSDate *startdate=[NSDate dateWithTimeIntervalSince1970:dateInTime];
    return cell;
    }
    else if(tableView==_offeredList){
        staleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"offeredCell" forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  
}
#pragma -mark request
-(void)OfferRequest{
    NSDictionary *para=@{@"type":@1,@"pageNum":@(offerPageNum),@"pageSize":@(pageSize)};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"%@",responseObject[@"content"]);
        if([responseObject[@"result"]integerValue]==1){
       
            NSDictionary *result=responseObject[@"content"][@"Aviation_demand"];
            NSMutableArray *list=result[@"list"];
            offerLast=[result[@"isLastPage"]boolValue];
            if(offerPageNum==1){
                 [_offerArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                OfferModel *offerModel=[[OfferModel alloc]initWithDict:dict];
                [_offerArr addObject:offerModel];
            }
            [_offeringList reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
    }];
}
@end
