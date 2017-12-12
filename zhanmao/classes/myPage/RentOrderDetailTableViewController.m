//
//  RentOrderDetailTableViewController.m
//  zhanmao
//
//  Created by bangju on 2017/11/21.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "RentOrderDetailTableViewController.h"
#import "RentOrderTableViewCell.h"
#import "OrderDetailAddressCell.h"
#import "OrderDetailStatusSimpleStyleCell.h"
#import "OrderDetailSimpleLeftLabelCell.h"
#import "TotalFeeView.h"

@interface RentOrderDetailTableViewController ()

@end

@implementation RentOrderDetailTableViewController
{
    TotalFeeView* _totalFeeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"租赁订单详情";
    
    [self.bottomButton removeFromSuperview];
    _totalFeeView=[[[UINib nibWithNibName:@"TotalFeeView" bundle:nil]instantiateWithOwner:nil options:nil]firstObject];
    CGRect fr=self.bottomToolBar.bounds;
    fr.size.height=64;
    _totalFeeView.frame=fr;
    _totalFeeView.title.text=@"总计：";
    [_totalFeeView.submitButton addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolBar addSubview:_totalFeeView];
    
    [self reloadWithOrder];
    
    [self refresh];
}

-(void)refresh
{
    [OrderTypeDataSource getMyRentOrderDetailById:self.rentModel.idd token:[UserModel token] success:^(RentOrderModel *model) {
        if (model.idd.length>0) {
            self.rentModel=model;
            [self reloadWithOrder];
        }
    }];
}

-(void)countingDown
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadWithOrder
{
    
    
    if (self.rentModel.order_status==RentOrderStatusNotPaid) {
        UIBarButtonItem* cancelItem=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOrder)];
        self.navigationItem.rightBarButtonItem=cancelItem;
        _totalFeeView.title.text=@"需付款：";
    }
    else
    {
        self.navigationItem.rightBarButtonItem=nil;
        _totalFeeView.title.text=@"总计：";
    }
    
    NSString* buttonString=[RentOrderModel cellButtonTitleForType:self.rentModel.order_status];
    [_totalFeeView.submitButton setTitle:buttonString forState:UIControlStateNormal];
    [_totalFeeView.grayButton setTitle:buttonString forState:UIControlStateNormal];
    
    _totalFeeView.submitButton.hidden=!(self.rentModel.order_status==RentOrderStatusNotPaid||self.rentModel.order_status==RentOrderStatusNotReturned);
    _totalFeeView.grayButton.hidden=!_totalFeeView.submitButton.hidden;
    
    _totalFeeView.feeLabe.text=[NSString stringWithFloat:self.rentModel.amount headUnit:@"¥" tailUnit:nil];
    
    [self.tableView reloadData];
}

-(void)cancelOrder
{
    NSLog(@"cancel order");
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //do cancel actioin
        [MBProgressHUD showProgressMessage:@"正在取消"];
        [OrderTypeDataSource postMyRentOrderCancelById:self.rentModel.idd token:[UserModel token] success:^(BOOL result, NSString *msg) {
            if (result) {
                [MBProgressHUD showSuccessMessage:msg];
                self.rentModel.order_status=-1;
#warning 租赁订单哪种取消状态？
                [self reloadWithOrder];
                
                [OrderTypeDataSource postOrderStatusChangedNotificationWithOrder:self.rentModel];
            }
            else
            {
                [MBProgressHUD showErrorMessage:msg];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else if(section==1)
    {
        NSInteger row=self.rentModel.goods.count+2;
        if (self.rentModel.order_status!=RentOrderStatusNotPaid)
        {
            row=row+1; //showing pay method:
        }
        return row;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec=indexPath.section;
    NSInteger row=indexPath.row;
    
    if (sec==0) {
        if (row==0) {
            OrderDetailStatusSimpleStyleCell* statusCell=[tableView dequeueReusableCellWithIdentifier:@"OrderDetailStatusSimpleStyleCell" forIndexPath:indexPath];
            statusCell.title.text=nil;
            statusCell.detail.text=nil;
            statusCell.title.text=[RentOrderModel detailHeaderTitleForType:self.rentModel.order_status];
            NSString* detailString=[RentOrderModel detailHeaderDescritionForType:self.rentModel.order_status];
            
            if (self.rentModel.order_status==RentOrderStatusNotPaid) {
                CGFloat expir=self.rentModel.expiration;
                CGFloat current=[[NSDate date]timeIntervalSince1970];
                CGFloat seconds=expir-current;
                if (seconds<0) {
                    seconds=0;
                }
                NSInteger mins=((int)seconds)/60;
                NSInteger secs=((int)seconds)%60;
                NSString* countDownTime=[NSString stringWithFormat:@"%ld分%ld秒",mins,secs];
                
                if ([detailString containsString:@"%@"]) {
                    detailString=[NSString stringWithFormat:detailString,countDownTime];
                }
            }
            
            statusCell.detail.text=detailString;
            return statusCell;
        }
        else if(row==1)
        {
            OrderDetailAddressCell* addressCell=[tableView dequeueReusableCellWithIdentifier:@"OrderDetailAddressCell" forIndexPath:indexPath];
            addressCell.name.text=self.rentModel.address.addressee;
            addressCell.phone.text=self.rentModel.address.phone;
            addressCell.address.text=[NSString stringWithFormat:@"%@%@%@",self.rentModel.address.province,self.rentModel.address.city,self.rentModel.address.district];
            return addressCell;
        }
        else if(row==2)
        {
            OrderDetailSimpleLeftLabelCell* emergCell=[tableView dequeueReusableCellWithIdentifier:@"OrderDetailSimpleLeftLabelCell" forIndexPath:indexPath];
            emergCell.label.text=[NSString stringWithFormat:@"%@%@",@"紧急联系人：",self.rentModel.emergency_phone?:@""];;
            return emergCell;
        }
    }
    else if(sec==1)
    {
        NSInteger totalRowOfSection=[tableView numberOfRowsInSection:sec];
        
        BOOL isPaid=self.rentModel.order_status!=RentOrderStatusNotPaid;
        
        if (row==totalRowOfSection-1) {
            OrderDetailSimpleLeftLabelCell* longDetailCell=[tableView dequeueReusableCellWithIdentifier:@"OrderDetailSimpleLeftLabelCell" forIndexPath:indexPath];
            
            NSString* detailString=@"";
            if (self.rentModel.number.length>0) {
                detailString=[NSString stringWithFormat:@"%@%@%@",detailString,@"订单编号：",self.rentModel.number];
            }
            if (self.rentModel.createtime.length>0) {
                detailString=[NSString stringWithFormat:@"%@\n%@%@",detailString,@"下单时间：",self.rentModel.createtime];
            }
            if (self.rentModel.paytime.length>0) {
                detailString=[NSString stringWithFormat:@"%@\n%@%@",detailString,@"支付时间：",self.rentModel.paytime];
            }
            if (self.rentModel.delivery_date.length>0) {
                detailString=[NSString stringWithFormat:@"%@\n%@%@",detailString,@"配送时间：",self.rentModel.delivery_date];
            }
            if (self.rentModel.return_date.length>0) {
                detailString=[NSString stringWithFormat:@"%@\n%@%@",detailString,@"归还时间：",self.rentModel.return_date];
            }
            if (self.rentModel.recover_date.length>0) {
                detailString=[NSString stringWithFormat:@"%@\n%@%@",detailString,@"回收时间：",self.rentModel.recover_date];
            }
            longDetailCell.label.text=detailString;
            return longDetailCell;
        }
        else if ((isPaid&&row==totalRowOfSection-2)) {
            OrderDetailSimpleLeftLabelCell* payMethodCell=[tableView dequeueReusableCellWithIdentifier:@"OrderDetailSimpleLeftLabelCell" forIndexPath:indexPath];
            payMethodCell.label.text=@"?";
            return payMethodCell;
        }
        else if((isPaid&&row==totalRowOfSection-3)||(!isPaid&&row==totalRowOfSection-2))
        {
            RentOrderTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"RentOrderTableViewCellPriceDetail" forIndexPath:indexPath];
            cell.orderModel=self.rentModel;
            return cell;
        }
        else
        {
            RentOrderTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"RentOrderTableViewCellProductDetail" forIndexPath:indexPath];
            if(row<self.rentModel.goods.count)
            {
                RentCartModel* goo=[self.rentModel.goods objectAtIndex:row];
                cell.cartModel=goo;
            }
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}

-(void)doAction
{
    
}

@end
