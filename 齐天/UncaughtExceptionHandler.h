//
//  UncaughtExceptionHandler.h
//  UncaughtExceptions
//  Created by StevenHu on 2014/11/13.
//  Copyright ‍2014/11/13 StevenHu. All rights reserved.
//
//
typedef enum{
    NONE=0,
    ERROR=1,
    INFO=2,
    
}Debug_lever;

#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject{
	BOOL dismissed;
}
@property(nonatomic,assign)Debug_lever debugLever;
+(instancetype)shareInstance;
FOUNDATION_EXPORT void MRLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
@end

