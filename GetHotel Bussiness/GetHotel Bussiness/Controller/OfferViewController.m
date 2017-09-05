//
//  OfferViewController.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "OfferViewController.h"
#import "quoteTableViewCell.h"
#import "POP.h"
#import "CityListViewController.h"
@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *quoteTable;
- (IBAction)depart:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)destination:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *departButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkDepartCity:) name:@"depart" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkDestinationCity:) name:@"destination" object:nil];
    self.quoteTable.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Navigation
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"报价";
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置是否需要毛玻璃效果
    //self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
    
    //设置边框颜色
    //   _chooseHotelBtn.layer.borderColor = [[UIColor redColor] CGColor];
    //    //设置边框宽度
    //    _chooseHotelBtn.layer.borderWidth = 1.0f;
    //   _chooseHotelBtn.layer.masksToBounds = YES;
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
}
//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    quoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
    return cell;
}
//创建左滑删除按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //先删数据 再删UI
       
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    return @[deleteAction];
}
#pragma -action
- (IBAction)ConfirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UITouch *touch=[[event allTouches] anyObject];
    //触摸实例在特定坐标系中的位置
    CGPoint location=[touch locationInView:_confirmButton];
    //创一个视图座位涟漪效果的展示体，以point为中心
    UIView *ripple=[[UIView alloc]initWithFrame:CGRectMake(location.x-10, location.y-10, 20, 20)];
    ripple.layer.cornerRadius=10;
    ripple.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
    [_confirmButton addSubview:ripple];
    POPBasicAnimation *rippleSizeAnimation=[POPBasicAnimation animation];
    rippleSizeAnimation.property=[POPAnimatableProperty propertyWithName:kPOPLayerSize];
    rippleSizeAnimation.duration=0.5;
    rippleSizeAnimation.toValue=[NSValue valueWithCGSize:CGSizeMake((_confirmButton.frame.size.width+_confirmButton.frame.size.height)*2, (_confirmButton.frame.size.width+_confirmButton.frame.size.height)*2)];
    [ripple pop_addAnimation:rippleSizeAnimation forKey:@"rippleSizeAnimation"];
    
    POPBasicAnimation *rippleCRAnimation =[POPBasicAnimation animation];
    rippleCRAnimation.property=[POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
    rippleCRAnimation.duration=0.5;
    rippleCRAnimation.toValue=@(_confirmButton.frame.size.width+_confirmButton.frame.size.height);
    [ripple.layer pop_addAnimation:rippleCRAnimation forKey:@"rippleCRAnimation"];
    rippleCRAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [ripple removeFromSuperview];
        //具体按钮事件的逻辑可以在这里开始执行
    };

}
#pragma mark - Action
- (IBAction)depart:(UIButton *)sender forEvent:(UIEvent *)event {
      NSNumber  *tag=@0;
   // [self performSegueWithIdentifier:@"departAction" sender:tag];
    CityListViewController *cityListVC=[Utilities getStoryboardInstance:@"AirPrice" byIdentity:@"CityListID"];
    [cityListVC setTag:tag];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:cityListVC];
    [self presentViewController:nc animated:YES completion:nil];
}


- (IBAction)destination:(UIButton *)sender forEvent:(UIEvent *)event {
    NSNumber  *tag=@1;
    // [self performSegueWithIdentifier:@"departAction" sender:tag];
    CityListViewController *cityListVC=[Utilities getStoryboardInstance:@"AirPrice" byIdentity:@"CityListID"];
    [cityListVC setTag:tag];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:cityListVC];
    [self presentViewController:nc animated:YES completion:nil];
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    CityListViewController *CityListViewController=[segue destinationViewController];
//    if ([segue.identifier isEqualToString:@"departAction"]) {
//        CityListViewController.tag=sender;
//    }else{
//        CityListViewController.tag=sender;
//    }
//}
#pragma  mark - notification
-(void)checkDepartCity:(NSNotification *)note{
    NSString *cityStr=note.object;
    if(![_departButton.titleLabel.text isEqualToString:cityStr]){
        [_departButton setTitle:cityStr forState:UIControlStateNormal];
    }
}
-(void)checkDestinationCity:(NSNotification *)note{
    NSString *cityStr=note.object;
    if(![_destinationButton.titleLabel.text isEqualToString:cityStr]){
        [_destinationButton setTitle:cityStr forState:UIControlStateNormal];
}
}
@end
