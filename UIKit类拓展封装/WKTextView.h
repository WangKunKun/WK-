//
//  WKTextView.h
//  Example
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKTextView;

@protocol WKTextViewDelegate <NSObject>

- (void)WKTextViewDidBeginEditing:(WKTextView *)textView;
- (void)WKTextViewDidEndEditing:(WKTextView *)textView;

@end

@interface WKTextView : UITextView


@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, assign) id<WKTextViewDelegate> wkdelegate;

@end
