//
//  WKCodeButton.m
//  testViewFromXib
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 Jian Fang. All rights reserved.
//

#import "WKCodeButton.h"


@interface SpecialBlock ()
@property (nonatomic, assign) NSUInteger specialTime;
@property (nonatomic, copy) specialBlock specialBlock;//特殊事件触发Block——可拓展为队列
@end
@implementation SpecialBlock

- (id)initWithTime:(NSUInteger)time block:(specialBlock)block
{
    if (self = [super init]) {
        self.specialTime = time;
        self.specialBlock = block;
    }
    return self;
}

@end

@interface WKCodeButton ()<WKTimerHolderDelegate>

@property (nonatomic, strong)WKTimerHolder * timerHolder;

//block执行完成标识，方便初始化timer
@property (nonatomic, assign) BOOL countStartBlockFinished;

@property (nonatomic, assign) BOOL CountEndBlockFinished;

@property (nonatomic, assign) NSUInteger count;

@end

@implementation WKCodeButton

- (void)setNormalTitle:(NSString *)normalTitle
{
    //防止闪烁
    self.titleLabel.text = normalTitle;
    [self setTitle:normalTitle forState:UIControlStateNormal];
}


//执行完毕，开始
- (void)setCountStartBlockFinished:(BOOL)countStartBlockFinished
{
    _countStartBlockFinished = countStartBlockFinished;
    if (_countStartBlockFinished) {
        [self initTimer];
    }
}

//计数事件执行完毕后的拓展
- (void)setCountEndBlockFinished:(BOOL)CountEndBlockFinished
{
    _CountEndBlockFinished = CountEndBlockFinished;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.normalTitle = @"获取验证码";
        _timerHolder = [[WKTimerHolder alloc] init];
        _countStartBlockFinished = NO;
        _maxTime = 30;
        _specialOperationArray = [NSMutableArray array];
        _isCounting = NO;
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalTitle = @"获取验证码";
        _countStartBlockFinished = NO;
        _maxTime = 30;
        _isCounting = NO;
        _specialOperationArray = [NSMutableArray array];
        _timerHolder = [[WKTimerHolder alloc] init];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)initTimer
{
    [self.timerHolder startTimer:1.0 repeats:YES delegate:self];
    _count = 0;
    _isCounting = YES;
    self.enabled = NO;
}

- (void)click:(UIButton *)button
{
    if (self.clickBlock != nil) {
        self.countStartBlockFinished = self.clickBlock();
    }
    else
    {
        self.countStartBlockFinished = YES;
    }
}

- (void)onWKTimerFired:(WKTimerHolder *)timerHolder
{
    
    [self setNormalTitle:[NSString stringWithFormat:@"%lus",_maxTime - _count]];
    
    if (_count ++ >= _maxTime) {
        [self setNormalTitle:@"获取验证码"];
        //倒计时结束 定时器停止。
        [_timerHolder stopTimer];
        _isCounting = NO;
        self.enabled = YES;
        if (self.countEndBlock != nil) {
            self.countStartBlockFinished = self.countEndBlock();
        }
    }
    
    for (SpecialBlock * temp in _specialOperationArray) {
        if(temp.specialTime == _maxTime - _count - 1)
        {
            temp.specialBlock();
        }
    }
    
}

@end
