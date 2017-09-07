//
//  HotelIssuedViewController.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelIssuedViewController.h"
#import "MyHotelTableViewCell.h"
@interface HotelIssuedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;

@end

@implementation HotelIssuedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    
    NSDictionary *dictA = @{@"hotelName":@"海天大酒店",@"hotelArea":@"39",@"hotelDescribe":@"含早 大床",@"hotelPrice":@"500",@"hotelImg":@"hotel"};
    
    NSDictionary *dictB = @{@"hotelName":@"天马行空大酒店",@"hotelArea":@"79",@"hotelDescribe":@"含早 大床",@"hotelPrice":@"600",@"hotelImg":@"setting"};
    
    NSDictionary *dictC = @{@"hotelName":@"滴滴滴大酒店",@"hotelArea":@"130",@"hotelDescribe":@"含早 套房",@"hotelPrice":@"900",@"hotelImg":@"hotel"};
    _arr = [NSMutableArray arrayWithObjects:dictA,dictB,dictC, nil];
    self.hotelTableView.tableFooterView = [UIView new];
    
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
    NSDictionary *dict = _arr[indexPath.row];
    cell.hotelNameLabel.text = dict[@"hotelName"];
    cell.hotelDescribeLabel.text = dict[@"hotelDescribe"];
    cell.hotelAreaLabel.text = dict[@"hotelArea"];
    cell.hotelPriceLabel.text = dict[@"hotelPrice"];
    
    //[_arr addObject:hotelModel];
    //[_hotelTableView reloadData];
    
    //_arr = @[dictA,dictB,dictC];
    //HotelDetailModel *hotelModel = _arr[indexPath.row];
    //    cell.hotelNameLabel.text = hotelModel.hotelName;
    //    cell.hotelPirceLabel.text = hotelModel.hotelPrice;
    //    cell.hotelAreaLabel.text = hotelModel.hotelArea;
    //    cell.hotelDescribeLabel.text = hotelModel.hotelDescribe;
    /*
     if (indexPath.row == 0){
     cell.hotelNameLabel.text = @"海天大酒店";
     cell.hotelImg.image = [UIImage imageNamed:@"hotels"];
     cell.hotelAreaLabel.text = @"39";
     cell.hotelPirceLabel.text = @"500";
     cell.hotelDescribeLabel.text = @"含早 大床";
     
     }else if (indexPath.row == 1){
     cell.hotelNameLabel.text = @"天马行空大酒店";
     cell.hotelDescribeLabel.text = @"不含早 大床";
     cell.hotelPirceLabel.text = @"999";
     cell.hotelAreaLabel.text = @"79";
     cell.hotelImg.image = [UIImage imageNamed:@"setting"];
     }else {
     cell.hotelNameLabel.text = @"滴滴滴大酒店";
     cell.hotelDescribeLabel.text = @"含早 套房";
     cell.hotelPirceLabel.text = @"1999";
     cell.hotelAreaLabel.text = @"179";
     cell.hotelImg.image = [UIImage imageNamed:@"hotel"];
     }
     */
    
    //NSDictionary *dictC = @{@"hotelName":@"书香世家大酒店",@"hotelDescribe":@"含早 套房",@"hotelArea":@"129平米",@"hotelPrice":@"1500",@"hotelImg":@"hotel"};
    
    //cell.hotelNameLabel.text = _arr[@"hotelName"];
    
    
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

#pragma mark - request
- (void)request{
    
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
