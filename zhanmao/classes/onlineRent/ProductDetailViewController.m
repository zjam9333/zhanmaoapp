//
//  ProductDetailViewController.m
//  zhanmao
//
//  Created by bangju on 2017/10/25.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailInfoTableViewCell.h"
#import "ProductParameterTableViewCell.h"

#import "RentCartTableViewController.h"

#import "RentActionEditView.h"

@interface ProductDetailViewController ()<RentActionEditViewDelegate>

@end

@implementation ProductDetailViewController
{
    AdvertiseView* photoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"产品详情";
    
    photoView=[[AdvertiseView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.width*0.6)];
    photoView.picturesUrls=[NSArray arrayWithObjects:
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508838600421&di=657bb23fe8427c3b0bd101fe297214d2&imgtype=0&src=http%3A%2F%2Fwww.im4s.cn%2Ftrade%2Fuploads%2Fallimg%2F160606%2F456-160606114A6326.jpg",
                            @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1889566272,4112726323&fm=27&gp=0.jpg",nil];
    self.tableView.tableHeaderView=photoView;
    
    [self.bottomButton setTitle:@"加入租赁车" forState:UIControlStateNormal];
    [self.bottomButton setImage:[UIImage imageNamed:@"a.png"] forState:UIControlStateNormal];
    [self.bottomButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ProductDetailInfoTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"ProductDetailInfoTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section==1)
    {
        ProductParameterTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"ProductParameterTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

-(void)bottomToolBarButtonClicked
{
//    RentCartTableViewController* cart=[[UIStoryboard storyboardWithName:@"OnlineRent" bundle:nil]instantiateViewControllerWithIdentifier:@"RentCartTableViewController"];
//    [self.navigationController pushViewController:cart animated:YES];
    
    RentActionEditView* action=[RentActionEditView defaultView];
    action.delegate=self;
    [action show];
}

@end
