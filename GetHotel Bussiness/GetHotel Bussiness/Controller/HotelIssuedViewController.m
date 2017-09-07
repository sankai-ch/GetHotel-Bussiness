//
//  HotelIssuedViewController.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelIssuedViewController.h"
#import "MyHotelTableViewCell.h"
#import "ReleaseHotelViewController.h"
#import "FindHotelModel.h"
@interface HotelIssuedViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pageNum;
    BOOL hotelLast;
}
@property (strong, nonatomic) NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;
- (IBAction)pushAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) NSMutableArray *typeArr;
@property (strong, nonatomic) NSMutableArray *resetArr;

@end

@implementation HotelIssuedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    _typeArr = [NSMutableArray new];
    _resetArr = [NSMutableArray new];
    
    _hotelTableView.tableFooterView = [UIView new];
    
    pageNum = 1;
    
    [self initializeData];
    [self setRefreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueRoom:) name:@"issue" object:nil];
    
    [self naviConfig];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)issueRoom:(NSNotification *)notification{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation导航条
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"我的酒店";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 200);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //设置导航条是否被隐藏
    [self.navigationController setNavigationBarHidden:YES];
    
}




#pragma mark - tableView
//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arr.count;
}


//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    MyHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHotel" forIndexPath:indexPath];
    FindHotelModel *findHotel =_arr[indexPath.row];
    //访问权限
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }

    //将URL中的字符以数组的形式分开存放
    for(NSInteger i = 0; i < _typeArr.count; i++){
        _resetArr = _typeArr[i];
        cell.hotelDescribeLabel.text = [NSString stringWithFormat:@"%@ %@", _resetArr[2],_resetArr[1]];
        
        cell.hotelAreaLabel.text = _resetArr[3];
    }
    
    NSURL *url = [NSURL URLWithString:findHotel.hotelImg];
    //cell.hotelImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:findHotel.roomImg]]];
    [cell.hotelImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hotels"]];
    
    cell.hotelNameLabel.text = findHotel.hotelName;
    cell.hotelPriceLabel.text = [NSString stringWithFormat:@"%ld",(long)findHotel.price];
    //cell.hotelDescribeLabel.text = findHotel.hotelType;
    NSLog(@"hotelName = %@",findHotel.hotelName);
    
    return cell;
}
//创建左滑删除按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //先删数据 再删UI
        [_arr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    return @[deleteAction];
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

//细胞选中后做什么
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == _arr.count - 1){
        if(!hotelLast) {
            pageNum ++;
            [self request];
        }
    }
}

#pragma mark - request

//下拉刷新
- (void)setRefreshControl{
    UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
    acquireRef.tag = 10001;
    [_hotelTableView addSubview:acquireRef];
}
- (void)acquireRef{
    [self request];
}
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self request];
}

- (void)request{
    NSDictionary *para = @{@"business_id":@1};
    [RequestAPI requestURL:@"/findHotelBySelf" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject[@"content"]);
        UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10001];
        [ref endRefreshing];
        
        if ([responseObject[@"result"]integerValue] == 1) {
            
            [_avi stopAnimating];
            NSArray *arr = responseObject[@"content"];
            
            NSLog(@"123=%@",arr);
            
            for(NSDictionary *dict in arr ){
                //用类中FindHotelModel类中定义的初始化方法initWithDict:将遍历得来的字典dict 转换成字典对象
                FindHotelModel *findModel = [[FindHotelModel alloc] initWithDict:dict];
                //将实例好的model对象插入_arr数组中
                [_arr addObject:findModel];
                NSString *roomInfoJSONStr = dict[@"hotel_type"];
                id roomInfoObj = [roomInfoJSONStr JSONCol];
                [_typeArr addObject:roomInfoObj];
            }
            //NSLog(@"%@",_typeArr[1]);
            //重载数据
            [_hotelTableView reloadData];
        }else {
            [_avi stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"错误码:%ld",(long)statusCode);
        UIRefreshControl *ref = (UIRefreshControl *)
        [_hotelTableView viewWithTag:10004];
        [ref endRefreshing];
        //[Utilities forceLogoutCheck:statusCode fromViewController:self];
        
        //[Utilities force]
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)pushAction:(UIButton *)sender forEvent:(UIEvent *)event {
    ReleaseHotelViewController *Release = [Utilities getStoryboardInstance:@"HotelIssued" byIdentity:@"ReleaseHotel"];
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:Release];
    
    [self presentViewController:nc animated:YES completion:nil];
    
    //[self.navigationController pushViewController:nc animated:YES];
    //[self.navigationController pushViewController:nc animated:YES];
}
@end
