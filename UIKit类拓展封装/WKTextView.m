
//
//  WKTextView.m
//  Example
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKTextView.h"

@interface WKTextView ()<UITextViewDelegate>

@end

@implementation WKTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    self.delegate = self;
}


- (void)setPlaceholder:(NSString *)placeholder
{
    
    _placeholder = placeholder;
    if (self.text.length < 1) {
        self.text = _placeholder;
        self.textColor = [UIColor lightGrayColor];
    }
}



- (void)setText:(NSString *)text
{
    
    [super setText:text];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.text.length > 0) {
        self.textColor = [UIColor blackColor];
    }
    else
    {
        self.text = _placeholder;
        self.textColor = [UIColor lightGrayColor];
    }
    
    if (_wkdelegate) {
        if ([_wkdelegate respondsToSelector:@selector(WKTextViewDidEndEditing:)]) {
            [_wkdelegate WKTextViewDidEndEditing:self];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textColor = [UIColor blackColor];
    self.text = @"";
    if (_wkdelegate) {
        if ([_wkdelegate respondsToSelector:@selector(WKTextViewDidEndEditing:)]) {
            [_wkdelegate WKTextViewDidBeginEditing:self];
        }
    }
}

@end
