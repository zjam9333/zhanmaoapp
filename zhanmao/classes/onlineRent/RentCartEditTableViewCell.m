//
//  RentCartEditTableViewCell.m
//  zhanmao
//
//  Created by bangju on 2017/10/25.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "RentCartEditTableViewCell.h"

@implementation RentCartEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.countStepper.min=1;
    self.dayStepper.min=1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEditing:(BOOL)editing
{
    self.editingBg.hidden=!editing;
    self.normalBg.hidden=editing;
    self.title.hidden=editing;
}

-(void)setCartModel:(RentCartModel *)cartModel
{
    _cartModel=cartModel;
    
    if (cartModel.selected) {
        //[self.selectButton setTitle:@"$" forState:UIControlStateNormal];
        self.selectButton.backgroundColor=[UIColor blueColor];
    }
    else
    {
        //[self.selectButton setTitle:@"" forState:UIControlStateNormal];
        self.selectButton.backgroundColor=[UIColor lightGrayColor];
    }
    
    self.title.text=cartModel.product.name;
    
    self.countStepper.value=cartModel.count;
    self.dayStepper.value=cartModel.days;
    
    self.count.text=[NSString stringWithFormat:@"%ld",(long)cartModel.count];
    self.days.text=[NSString stringWithFormat:@"%ld",(long)cartModel.days];
}

- (IBAction)selectedButtonClick:(id)sender {
    self.cartModel.selected=!self.cartModel.selected;
    self.cartModel=self.cartModel;
}

- (IBAction)deleteButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(rentCartEditTableViewCell:deleteCartModel:)]) {
        [self.delegate rentCartEditTableViewCell:self deleteCartModel:self.cartModel];
    }
}

- (IBAction)countStepperValueChanged:(ZZStepper*)sender {
    self.cartModel.count=sender.value;
    self.cartModel=self.cartModel;
}

- (IBAction)daysStepperValueChanged:(ZZStepper*)sender {
    self.cartModel.days=sender.value;
    self.cartModel=self.cartModel;
}

@end