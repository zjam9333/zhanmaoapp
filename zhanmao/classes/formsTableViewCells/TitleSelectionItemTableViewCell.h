//
//  TitleSelectionItemTableViewCell.h
//  zhanmao
//
//  Created by bangju on 2017/10/23.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleSelectionItemTableViewCell : FormBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (nonatomic,assign) BOOL radioSelected;

@end
