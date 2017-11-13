//
//  MainPageTableViewController.m
//  zhanmao
//
//  Created by bangju on 2017/10/16.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "MainPageTableViewController.h"

#import "SimpleButtonsTableViewCell.h"
#import "ExhibitionLargeCardTableViewCell.h"
#import "SimpleHeaderTableViewCell.h"
#import "MainPageHeaderTableViewCell.h"
#import "MessageSmallTableViewCell.h"

#import "BaseFormTableViewController.h"
#import "ExhibitionListViewController.h"
#import "NaviController.h"

#import "ImageTitleBarButtonItem.h"

#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger,MainPageSection)
{
    MainPageSectionEights,
    MainPageSectionExhibitions,
    
    MainPageSectionTotalCount,
};

@interface MainPageTableViewController ()<SimpleButtonsTableViewCellDelegate,CLLocationManagerDelegate>
{
//    UIBarButtonItem* locationItem;
    NSArray* arrayWithSimpleButtons;
    NSMutableArray* messagesArray;
    
    CLLocationManager * locationManager;
    NSString * currentCity; //当前城市
}
@end

@implementation MainPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"展贸在线";
    self.tabBarItem.title=@"主页";
    
//    [self setLocation:@"guangz"];
    
//    self.tableView.contentInset=UIEdgeInsetsMake(-20, 0, 0, 0);
    
    UIBarButtonItem* searchItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchWhite"] style:UIBarButtonItemStylePlain target:self action:@selector(goSearch)];
    self.navigationItem.rightBarButtonItem=searchItem;
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainPageHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainPageHeaderTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SimpleHeaderTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ExhibitionLargeCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExhibitionLargeCardTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageSmallTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageSmallTableViewCell"];
    
    messagesArray=[NSMutableArray array];
    for (int i=0; i<10; i++) {
        [messagesArray addObject:@"a"];
    }
    
    [self locate];
//    self.tableView.sectionHeaderHeight=44;
}

- (void)locate {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager requestWhenInUseAuthorization];
        currentCity = [[NSString alloc] init];
        [locationManager startUpdatingLocation];
    }
    
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"未知";
            }
            NSLog(@"%@",currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
            [MBProgressHUD showErrorMessage:[NSString stringWithFormat:@"已定位到:%@",currentCity]];
            [self setLocation:currentCity];
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((NaviController*)self.navigationController) setNavigationColorShowImage:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [((NaviController*)self.navigationController) setNavigationColorShowImage:YES];
}

-(void)setLocation:(NSString*)location
{
    ImageTitleBarButtonItem* it=[ImageTitleBarButtonItem itemWithImageName:@"locationWhite" title:location target:self selector:@selector(selectLocation)];
    self.navigationItem.leftBarButtonItem=it;
}

-(void)goSearch
{
//    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"OnlineRent" bundle:nil]instantiateViewControllerWithIdentifier:@"ProductSearchTableViewController"] animated:YES];
    UIViewController* sear=[[UIStoryboard storyboardWithName:@"OnlineRent" bundle:nil]instantiateViewControllerWithIdentifier:@"ProductSearchTableViewController"];
    UINavigationController* nav=[[NaviController alloc]initWithRootViewController:sear];
    [self presentViewController:nav animated:YES completion:nil];
}

-(NSArray*)arrayWithSimpleButtons
{
    if (arrayWithSimpleButtons.count==0) {
        
        NSMutableArray* array=[NSMutableArray array];
        NSArray* titles=[NSArray arrayWithObjects:@"主场",@"展台",@"展厅",@"舞台",@"演艺",@"邀约",@"保洁",@"物流",@"",@"", nil];
        NSArray* images=[NSArray arrayWithObjects:@"zhuchang",@"zhantai",@"zhanting",@"wutai",@"yanyi",@"yaoyue",@"baojie",@"wuliu",@"",@"", nil];
        NSArray* identis=[NSArray arrayWithObjects:
                          @"ExhibitionListViewController",@"ExhibitionListViewController",
                          @"ExhibitionListViewController",@"ExhibitionListViewController",
                          @"ExhibitionListViewController",@"HuiyiFormTableViewController",
                          @"BaojieFormTableViewController",@"WuliuFormTableViewController", nil];
        for (NSInteger i=0; i<8; i++) {
            SimpleButtonModel* mo=[[SimpleButtonModel alloc]initWithTitle:[titles objectAtIndex:i] imageName:[images objectAtIndex:i] identifier:i<identis.count?[identis objectAtIndex:i]:@"" type:i+1];
            [array addObject:mo];
        }
        arrayWithSimpleButtons=array;
    }
    return arrayWithSimpleButtons;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLocation
{
    NSLog(@"select location");
//    [self setLocation:[NSString stringWithFormat:@"%ld",(long)(arc4random()%1000000)]];
    [locationManager startUpdatingLocation];
}

#pragma mark UITableViewDelegate&Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MainPageSectionTotalCount+messagesArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==MainPageSectionEights) {
        return 1;
    }
    else if(section==MainPageSectionExhibitions)
    {
        return 2;
    }
    else
    {
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger sec=indexPath.section;
//    if (sec==MainPageSectionEights) {
//        return [SimpleButtonsTableViewCell heightWithButtonsCount:[self arrayWithSimpleButtons].count];
//    }
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec=indexPath.section;
    NSInteger row=indexPath.row;
    NSInteger msgSection=sec-(tableView.numberOfSections-messagesArray.count);
    
    if(sec==MainPageSectionEights)
    {
        MainPageHeaderTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"MainPageHeaderTableViewCell" forIndexPath:indexPath];
        [cell setButtons:[self arrayWithSimpleButtons]];
        [cell setDelegate:self];
        return cell;
    }
    else
    {
        if (row==0) {
            SimpleHeaderTableViewCell* sim=[tableView dequeueReusableCellWithIdentifier:@"SimpleHeaderTableViewCell" forIndexPath:indexPath];
            if (sec==0) {
                //....
            }
            else if(sec==1)
            {
                //....
            }
            return sim;
        }
        else if(sec==MainPageSectionExhibitions)
        {
            
            ExhibitionLargeCardTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"ExhibitionLargeCardTableViewCell" forIndexPath:indexPath];
            return cell;
        }
        else
        {
            MessageSmallTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"MessageSmallTableViewCell" forIndexPath:indexPath];
            cell.showImage=(msgSection%3==0);
            cell.showReadCount=(msgSection%2==0);
            return cell;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section==0)
//    {
//        return 0.01;
//    }
//    return 44;
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ExhibitionLargeCardTableViewCell class]]) {
        [((ExhibitionLargeCardTableViewCell*)cell) setCornerRadius];
    }
}

#pragma mark SimpleButtonsTableViewCellDelegate

-(void)simpleButtonsTableViewCell:(SimpleButtonsTableViewCell *)cell didSelectedModel:(SimpleButtonModel *)model
{
    NSLog(@"%@",model.title);
    if (model.identifier.length>0) {
        Class cla=NSClassFromString(model.identifier);
        BaseFormTableViewController* form=[[cla alloc]init];
        if ([form isKindOfClass:[BaseFormTableViewController class]]) {
            
            [self.navigationController pushViewController:form animated:YES];
            return;
        }
        UIStoryboard* sb=[UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
            
        ExhibitionListViewController* viewController=[sb instantiateViewControllerWithIdentifier:model.identifier];
        if([viewController isKindOfClass:[ExhibitionListViewController class]])
        {
            viewController.type=model.type;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
