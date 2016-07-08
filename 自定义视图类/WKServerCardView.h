//
//  WKServerCardView.h
//  Example
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBaseModel.h"

@class ServerDetailModel;

typedef void(^ServerCardClick)(NSString * serverID);
@interface WKServerCardView : UIView
+ (instancetype)viewFromNIB;

@property (strong, nonatomic) IBOutlet UIImageView *BGView;
- (void)setInterFaceWithModel:(ServerDetailModel *)model;

@property (nonatomic, copy) ServerCardClick click;
@end
