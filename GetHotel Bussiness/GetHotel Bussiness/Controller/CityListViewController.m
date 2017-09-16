//
//  CityListViewController.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "CityListViewController.h"
#import "OfferViewController.h"
#import "CityListModel.h"
@interface CityListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelViewTralling;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (strong,nonatomic)NSMutableArray *cityListArr;
@property (strong,nonatomic)NSMutableArray *arr;
@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cityListArr=[NSMutableArray new];
    _arr=[NSMutableArray new];
    _tableView.tableFooterView=[UIView new];
    [self naviConfig];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWiiHide:) name:UIKeyboardWillHideNotification object:nil];
    [self requestCity];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_seachBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"机场列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)backAction{
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CityListModel *cityListModel=_cityListArr[section];
    return cityListModel.cityArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CityListCell" forIndexPath:indexPath];
    CityListModel *cityListModel=_cityListArr[indexPath.section];
    cell.textLabel.text=cityListModel.cityArr[indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CityListModel *cityListModel=_cityListArr[section];
    return cityListModel.tip;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityListModel *cityListModel=_cityListArr[indexPath.section];
    switch (_tag.integerValue) {
        case 0:
            [[NSNotificationCenter defaultCenter]performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"depart" object:cityListModel.cityArr[indexPath.row]] waitUntilDone:YES];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter]performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"destination" object:cityListModel.cityArr[indexPath.row]] waitUntilDone:YES];
            break;
        default:
            break;
            
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -searchBar
//-(void)seachBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if(searchText.length==0){
//        [self requestCity];
//        return;
//    }
////    [self requestOfFindCity:searchText];
//}
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [_seachBar resignFirstResponder];
//}
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    _cancelViewTralling.constant=0;
//    [UIView animateWithDuration:0.5f animations:^{
//        [self.view layoutIfNeeded];
//    }];
//}

#pragma mark - keyBorder
-(void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardRect=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _tableViewBottom.constant=keyboardRect.size.height;
}
-(void)keyboardWiiHide:(NSNotification *)notification{
    _tableViewBottom.constant=0;
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //NSLog(@"-----------------------------%lu",(unsigned long)_arr.count);
 
    return _arr;
}
#pragma mark - request

-(void)requestCity{
  
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airport" ofType:@"json"]];
    NSArray *airports = (NSArray *)[JSONData JSONCol];
    NSLog(@"airports = %@", airports);
    //NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [_arr removeAllObjects];
    [_cityListArr removeAllObjects];
    for(NSArray *airportGroup in airports){
        NSDictionary *group = airportGroup[0];
        NSString *groupStr = group[@"short"];
        [_arr addObject:groupStr];
        
        NSDictionary *aiportInGroup = airportGroup[1];
        NSArray *airportList = aiportInGroup[@"airportList"];
        NSDictionary *airportListInGroup = @{@"short":groupStr,@"airportList":airportList};
        CityListModel *cityList = [[CityListModel alloc] initWithDict:airportListInGroup];
        [_cityListArr addObject:cityList];
    }
    [_tableView reloadData];

}
//-(void)requestOfFindCity:(NSString *)text {
//    [RequestAPI requestURL:@"/getCityByName" withParameters:@{@"name":text,@"id":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        if([responseObject[@"result"] integerValue]==1){
//            NSArray *content=responseObject[@"content"];
//            [_cityListArr removeAllObjects];
//            [_arr removeAllObjects];
//            for(NSDictionary *dict in content){
//                CityListModel *cityModel=[[CityListModel alloc]initWithDict: dict];
//                [_cityListArr addObject:cityModel];
//            }
//            [_tableView reloadData];
//        }
//    } failure:^(NSInteger statusCode, NSError *error) {
//        
//    }];
//}
- (IBAction)cancelAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [_seachBar resignFirstResponder];
    _cancelViewTralling.constant=-50;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
