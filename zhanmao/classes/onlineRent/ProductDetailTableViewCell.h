//
//  ProductDetailTableViewCell.h
//  zhanmao
//
//  Created by bangju on 2017/10/25.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZStepper.h"

@interface ProductDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rent;
@property (weak, nonatomic) IBOutlet UILabel *deposit;
@property (weak, nonatomic) IBOutlet ZZStepper *stepper;

@end