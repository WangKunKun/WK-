//
//  WKTimerHolder.m
//  Example
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKTimerHolder.h"

@interface WKTimerHolder ()
{
    NSTimer *_timer;
    BOOL _repeats;
}

@property (nonatomic, weak) id<WKTimerHolderDelegate> timerDelegate;

- (void)onTimer:(NSTimer *)timer;

@end
@implementation WKTimerHolder

- (void)dealloc {
    [self stopTimer];
}
- (void)startTimer: (NSTimeInterval)seconds  repeats: (BOOL)repeats delegate: (id<WKTimerHolderDelegate>)delegate
{
    _repeats = repeats;
    _timerDelegate = delegate;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:nil repeats:repeats];
}
- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
    _timerDelegate = nil;
}



- (void)onTimer: (NSTimer *)timer {
    if (!_repeats) { _timer = nil; }
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(onWKTimerFired:)]) { [_timerDelegate onWKTimerFired:self]; }
}
@end
