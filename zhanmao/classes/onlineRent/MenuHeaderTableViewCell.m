//
//  MenuHeaderTableViewCell.m
//  zhanmao
//
//  Created by bangju on 2017/10/23.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "MenuHeaderTableViewCell.h"

@implementation MenuHeaderButtonModel

+(instancetype)modelWithTitle:(NSString *)title selected:(BOOL)selected ordered:(BOOL)ordered ascending:(BOOL)ascending
{
    MenuHeaderButtonModel* m=[[MenuHeaderButtonModel alloc]init];
    m.title=title;
    m.selected=selected;
    m.ordered=ordered;
    m.ascending=ascending;
    return m;
}

@end

@interface MenuHeaderTableViewCell()

@property (nonatomic,strong) UIView* bottomSeperateLine;

@end

@implementation MenuHeaderTableViewCell

-(void)setButtonModelArray:(NSArray<MenuHeaderButtonModel *> *)buttonModelArray
{
    _buttonModelArray=buttonModelArray;
    
    [self.contentView removeAllSubviews];
    
    self.contentView.backgroundColor=[UIColor whiteColor];
//    self.backgroundColor=[UIColor whiteColor];
    
    CGFloat bw=64;
    CGFloat bh=32;
    CGFloat imgW=20;
    CGFloat imgH=imgW;
    for (NSInteger i=0; i<buttonModelArray.count; i++) {
        MenuHeaderButtonModel* model=[buttonModelArray objectAtIndex:i];
        
        UIView* bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bw, bh)];
        [self.contentView addSubview:bg];
        
        UILabel* ti=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bw-imgW, bh)];
        ti.text=model.title;
        ti.font=[UIFont systemFontOfSize:14];
//        ti.textColor=[UIColor darkGrayColor];
        ti.textAlignment=NSTextAlignmentCenter;
        [bg addSubview:ti];
        
        UILabel* upImg=[[UILabel alloc]initWithFrame:CGRectMake(bw-imgW, bh/2-imgH+4, imgW, imgH)];
        upImg.text=@"▲";
        upImg.textColor=[UIColor grayColor];
        upImg.font=[UIFont systemFontOfSize:14];
        upImg.textAlignment=NSTextAlignmentCenter;
        [bg addSubview:upImg];
        
        UILabel* doImg=[[UILabel alloc]initWithFrame:CGRectMake(bw-imgW, bh/2-4, imgW, imgH)];
        doImg.text=@"▼";
        doImg.textColor=[UIColor grayColor];
        doImg.font=[UIFont systemFontOfSize:14];
        doImg.textAlignment=NSTextAlignmentCenter;
        [bg addSubview:doImg];
        
        if (model.ordered==NO) {
            ti.frame=bg.bounds;
            upImg.hidden=YES;
            doImg.hidden=YES;
        }
        if (model.selected) {
            ti.textColor=_mainColor;
            if (model.ascending) {
                upImg.textColor=_mainColor;
            }
            else
            {
                doImg.textColor=_mainColor;
            }
        }
        
        UIButton* btn=[[UIButton alloc]initWithFrame:bg.bounds];
        btn.tag=i;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)buttonClicked:(UIButton*)button
{
    NSInteger tag=button.tag;
    MenuHeaderButtonModel* mo=[self.buttonModelArray objectAtIndex:tag];
    BOOL oldSelected=mo.selected;
    for (MenuHeaderButtonModel* m in self.buttonModelArray) {
        m.selected=NO;
    }
    mo.selected=YES;
    if (mo.ordered) {
        mo.ascending=!mo.ascending;
        if (oldSelected==NO) {
            mo.ascending=YES;
        }
    }
    self.buttonModelArray=self.buttonModelArray;
    if ([self.delegate respondsToSelector:@selector(menuHeaderTableViewCell:didChangeModels:)]) {
        [self.delegate menuHeaderTableViewCell:self didChangeModels:self.buttonModelArray];
    }
}

-(UIView*)bottomSeperateLine
{
    if(_bottomSeperateLine==nil)
    {
        _bottomSeperateLine=[[UIView alloc]initWithFrame:CGRectZero];
        _bottomSeperateLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:_bottomSeperateLine];
    }
    return _bottomSeperateLine;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w=[self.contentView frame].size.width;
    CGFloat wp=w/self.buttonModelArray.count;
    CGFloat h=[self.contentView frame].size.height;
    
    for (NSInteger i=0;i<self.contentView.subviews.count;i++) {
        UIView* view=[self.contentView.subviews objectAtIndex:i];
        view.frame=CGRectMake(wp/2+(wp*i)-view.frame.size.width/2, h/2-view.frame.size.height/2, view.frame.size.width, view.frame.size.height);
    }
    CGFloat he=1/[[UIScreen mainScreen]scale];
    self.bottomSeperateLine.frame=CGRectMake(0, self.bounds.size.height-he, self.bounds.size.width, he);
}

@end