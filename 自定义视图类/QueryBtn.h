//
//  QueryBtn.h
//  Example
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WKQueryBtnStyleHint = 0,//其他地方订单的提示
    WKQueryBtnStyleHintAndClick,//主任务大厅的订单提示点击
    WKQueryBtnStyleExchange,//积分兑换界面
    WKQueryBtnStyleMargin,//保证金点击
    WKQueryBtnStyleMarginDetail,//保证金详细
    WKQueryBtnStyleComplaint
   
} WKQueryBtnStyle;

typedef void(^queryBtnClick)(void);

@interface QueryBtn : UIView

@property (nonatomic,assign) WKQueryBtnStyle style;
@property (nonatomic,copy) queryBtnClick click;

//开关
@property (nonatomic, assign) BOOL isClose;

@property (nonatomic, strong) NSString * integral;
+ (instancetype)viewFromNIBWithStyle:(WKQueryBtnStyle)style;



@end
