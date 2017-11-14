//
//  MyPageTableViewController.m
//  zhanmao
//
//  Created by bangju on 2017/10/20.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "MyPageTableViewController.h"
#import "MyPageHeaderTableViewCell.h"
#import "MyPageSimpleTableViewCell.h"
#import "MyPageCellModel.h"

//typedef NS_ENUM(NSInteger, MyPageSection) {
//    
//    MyPageSectionHeaders,
//    MyPageSectionPersonals,
//    MyPageSectionInvoices,
//    MyPageSectionHelps,
//    
//    MyPageSectionTotalCount,
//};
//


@interface MyPageTableViewController ()<SimpleButtonsTableViewCellDelegate,MyPageHeaderTableViewCellDelegate>
{
    NSArray* arrayWithSimpleButtons;
    NSArray* cellModelsArray;
    
    NSMutableDictionary* cachesControllers;
}
@end

@implementation MyPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarItem.title=@"我的";
    
    cachesControllers=[NSMutableDictionary dictionary];
    
    self.tableView.contentInset=UIEdgeInsetsMake(-21,0, 0, 0);
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyPageHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyPageHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyPageSimpleTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyPageSimpleTableViewCell"];
    
    cellModelsArray=[NSArray arrayWithObjects:
            [NSArray arrayWithObjects:
             [MyPageCellModel modelWithTitle:@"" image:@"" detail:@"" identifier:@""], nil],
            [NSArray arrayWithObjects:
             [MyPageCellModel modelWithTitle:@"地址管理" image:@"" detail:@"" identifier:@"MyAddressesTableViewController"],
             [MyPageCellModel modelWithTitle:@"个人资料" image:@"" detail:@"" identifier:@""], nil],
            [NSArray arrayWithObjects:
             [MyPageCellModel modelWithTitle:@"申请发票" image:@"" detail:@"" identifier:@"MyInvoicePagerViewController"],nil],
            [NSArray arrayWithObjects:
             [MyPageCellModel modelWithTitle:@"帮助中心" image:@"" detail:@"" identifier:@""],
             [MyPageCellModel modelWithTitle:@"意见反馈" image:@"" detail:@"" identifier:@""],
             [MyPageCellModel modelWithTitle:@"租赁协议" image:@"" detail:@"" identifier:@""],
             [MyPageCellModel modelWithTitle:@"客服电话" image:@"" detail:@"020-00000000" identifier:@""], nil],
            nil];
    
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)arrayWithSimpleButtons
{
    if (arrayWithSimpleButtons.count==0) {
        
        NSMutableArray* array=[NSMutableArray array];
        NSArray* tits=[NSArray arrayWithObjects:@"租赁订单",@"物流订单",@"保洁订单",@"定制订单", nil];
        NSArray* ides=[NSArray arrayWithObjects:@"RentOrderPagerViewController",@"TransportOrderPagerViewController",@"CleanOrderPagerViewController",@"CustomOrderPagerViewController", nil];
        
        for (NSInteger i=0; i<4; i++) {
            SimpleButtonModel* mo=[[SimpleButtonModel alloc]initWithTitle:[tits objectAtIndex:i] imageName:@"a" identifier:[ides objectAtIndex:i] type:i];
            [array addObject:mo];
        }
        arrayWithSimpleButtons=array;
    }
    return arrayWithSimpleButtons;
}

#pragma mark tableView delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cellModelsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==0) {
//        return 1;
//    }
//    else
//    {
        NSArray* arr=[cellModelsArray objectAtIndex:section];
        return arr.count;
//    }
//    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec=indexPath.section;
    NSInteger row=indexPath.row;
    if (sec==0) {
        MyPageHeaderTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"MyPageHeaderTableViewCell" forIndexPath:indexPath];
        [cell setButtons:[self arrayWithSimpleButtons]];
        [cell setDelegate:self];
        [cell setSimpleButtonsCellDelegate:self];
        return cell;
    }
    else
    {
        NSArray* arr=[cellModelsArray objectAtIndex:sec];
        MyPageCellModel* mo=[arr objectAtIndex:row];
        
        MyPageSimpleTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"MyPageSimpleTableViewCell" forIndexPath:indexPath];
        cell.title.text=mo.title;
        cell.image.image=[[UIImage imageNamed:mo.image]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.detail.text=mo.detail;
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* arr=[cellModelsArray objectAtIndex:indexPath.section];
    MyPageCellModel* mo=[arr objectAtIndex:indexPath.row];
    NSLog(@"%@",mo.identifier);
    if (indexPath.section==1) {
        //requires loging
//        return;
    }
    [self pushToViewControllerId:mo.identifier];
}

#pragma mark SimpleButtonsTableViewCellDelegate

-(void)simpleButtonsTableViewCell:(SimpleButtonsTableViewCell *)cell didSelectedModel:(SimpleButtonModel *)model
{
    NSLog(@"%@",model.title);
    [self pushToViewControllerId:model.identifier];
}

-(void)pushToViewControllerId:(NSString*)identifier
{
    if (identifier.length>0) {
        UIViewController* viewController=[cachesControllers valueForKey:identifier];
        if (viewController==nil) {
            UIStoryboard* sb=[UIStoryboard storyboardWithName:@"MyPage" bundle:nil];
            NSLog(@"%@",sb);
            viewController=[sb instantiateViewControllerWithIdentifier:identifier];
            [cachesControllers setValue:viewController forKey:identifier];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma headerCellDelegate

-(void)myPageHeaderTableViewCellSettingButtonClicked:(MyPageHeaderTableViewCell *)cell
{
    [self pushToViewControllerId:@"MySettingTableViewController"];
}

-(void)myPageHeaderTableViewCellPersonalButtonClicked:(MyPageHeaderTableViewCell *)cell
{
    
}

@end
