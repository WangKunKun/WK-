//
//  WKCodeButton.h
//  testViewFromXib
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 Jian Fang. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "WKTimerHolder.h"
typedef BOOL(^codeBtnBlock)();
typedef void(^specialBlock)();

//特殊事件类
@interface SpecialBlock : NSObject

- (id)initWithTime:(NSUInteger)time block:(specialBlock)block;



@end

@interface WKCodeButton : UIButton

@property (nonatomic, strong) NSString * normalTitle;
//默认从30开始倒计时
@property (nonatomic, assign) NSUInteger maxTime;

@property (nonatomic, copy) codeBtnBlock clickBlock;//初次点击执行代码块

//特殊事件数组
@property (nonatomic, strong) NSMutableArray * specialOperationArray;

@property (nonatomic, copy) codeBtnBlock countEndBlock;//计数事件终止执行代码块

@property (nonatomic, assign, readonly) BOOL isCounting;

@end
