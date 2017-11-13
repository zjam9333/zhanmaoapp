//
//  BaseToolBarTableViewController.h
//  zhanmao
//
//  Created by bangju on 2017/10/24.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseToolBarTableViewController : BaseTableViewController

@property (nonatomic,strong) UIView* bottomToolBar;
@property (nonatomic,strong) UIButton* bottomButton;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,readonly,assign) CGRect bottomViewFrame;

-(void)bottomToolBarButtonClicked;

@end
