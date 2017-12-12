//
//  PayOrderCountDownHeaderView.m
//  zhanmao
//
//  Created by jam on 2017/12/5.
//  Copyright © 2017年 bangju. All rights reserved.
//

#import "PayOrderCountDownHeaderView.h"

@implementation PayOrderCountDownHeaderView
{
    NSTimer* timer;
}

-(void)setExpiration:(CGFloat)expiration
{
    _expiration=expiration;
    CGFloat currentTime=[[NSDate date]timeIntervalSince1970];
    self.totalTime=expiration-currentTime;
}

-(void)setTotalTime:(CGFloat)totalTime
{
    _totalTime=totalTime;
    self.leftTime=totalTime;
    [self setTimerIfNeed];
}

-(void)setTimerIfNeed
{
    if (timer==nil) {
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countingDown) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate date]];
    }
}

-(void)dealloc
{
    [timer invalidate];
}
               
-(void)countingDown
{
    if(self.leftTime>=0)
    {
        NSInteger totalSec=self.leftTime;
        NSInteger min=totalSec/60;
        NSInteger sec=totalSec%60;
        self.timeLabal.text=[NSString stringWithFormat:@"%d:%02d",(int)min,(int)sec];
        self.leftTime=self.leftTime-1;
    }
}

@end
