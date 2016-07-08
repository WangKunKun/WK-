//
//  Tools.h
//  UICollectionView
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Tools : NSObject

@property (nonatomic,strong,readonly) NSMutableArray<UIImage *> * myImages;


+ (Tools *)sharedTools;


@end

