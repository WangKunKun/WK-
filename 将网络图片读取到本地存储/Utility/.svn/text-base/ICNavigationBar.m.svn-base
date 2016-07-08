//
//  UIPCNavigationBar.m
//  sandscreen
//
//  Created by liuyang on 11-4-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ICNavigationBar.h"



#define HINT_DEFAULTWITH		15.0f
#define X_PADDING               8.0f
#define Y_PADDING               4.0f

#define TAG_SLIDER              100

@implementation ICNavigationItem
@synthesize title,image,index;

@end

@interface ICNavigationBar ()
{
    int    _currentIndex;

}

@end

@implementation ICNavigationBar

@synthesize navigationBarLeftHintImageView;
@synthesize navigationBarRightHintImageView;
@synthesize navigationBarSlider;
@synthesize navigationBarScrollView;
@synthesize	navigationBarItems;
@synthesize delegate;
@synthesize navigationSelectedItemImage;
@synthesize navigationSelectedTextColor;
@synthesize selectedIndex;
@synthesize navigationTextColor;
@synthesize navigationBarBG;
@synthesize navigationBarFG;
@synthesize textShadowEnable;
@synthesize sliderStyle;
@synthesize arranageCenter;
@synthesize sideXPadding;
@synthesize sideYPadding;
@synthesize unitPadding;



- (id)initWithFrame:(CGRect)frame autoCenter:(BOOL)value {
    
	if ((self = [super initWithFrame:frame])) {
        // Initialization code
		selectedIndex = 0;
		sliderEnable = NO;
        textShadowEnable = NO;
        arranageCenter = NO;
		autoCenterEnable = value;
        
        sideXPadding = 0;
        sideYPadding = 0;
        unitPadding = X_PADDING;
        
        sliderStyle = ICNavigationBarSliderStyle_InCase,
		navigationBarItems = [[NSMutableArray alloc] initWithCapacity:0];
		navigationBarButtons = [[NSMutableArray alloc] initWithCapacity:0];
		
		//navigationBarScrollView = [[UIPCScrollView alloc] initWithFrame:self.bounds];
        navigationBarScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		//navigationBarScrollView.scrollEnabled = YES;
		navigationBarScrollView.showsHorizontalScrollIndicator = NO;
		navigationBarScrollView.delegate = self;
		navigationBarLeftHintImageView = [[UIImageView alloc] init];
		navigationBarRightHintImageView = [[UIImageView alloc] init];
		navigationSelectedItemImage = nil;
		navigationSelectedTextColor = nil;
        navigationBarBG = [[UIImageView alloc] init];
        navigationBarFG = [[UIImageView alloc] init];
		
        [self addSubview:navigationBarBG];
		[self addSubview:navigationBarScrollView];
		[self addSubview:navigationBarLeftHintImageView];
		[self addSubview:navigationBarRightHintImageView];
        [self addSubview:navigationBarFG];
		[self setHintWidth:HINT_DEFAULTWITH];
		
		//navigationBarScrollView.backgroundColor = [UIColor blueColor];
		//navigationBarLeftHintImageView.backgroundColor = [UIColor clearColor];
		//navigationBarRightHintImageView.backgroundColor = [UIColor clearColor];
        //navigationBarScrollView.backgroundColor = [UIColor yellowColor];
    }
    return self;
    
}


- (void)layoutHintUI{
	navigationBarLeftHintImageView.frame = CGRectMake(0.0f,sideYPadding,hintWidth,self.frame.size.height-2*sideYPadding);
	navigationBarRightHintImageView.frame = CGRectMake(self.frame.size.width - hintWidth,sideYPadding,hintWidth,self.frame.size.height-2*sideYPadding);
}

- (void)layoutForOrientation:(CGRect)frame{
	self.frame = frame;
	navigationBarScrollView.frame = self.bounds;
	if (navigationBarScrollView.frame.size.width > navigationBarScrollView.contentSize.width) {
		navigationBarScrollView.scrollEnabled = NO;
	}else {
		navigationBarScrollView.scrollEnabled = YES;
	}
	[self layoutHintUI];
	if (navigationBarScrollView.contentOffset.x > 0) {
		navigationBarLeftHintImageView.alpha = 1;
	}else {
		navigationBarLeftHintImageView.alpha = 0;
	}
	if (navigationBarScrollView.contentSize.width - navigationBarScrollView.contentOffset.x <= navigationBarScrollView.bounds.size.width) {
		navigationBarRightHintImageView.alpha = 0;
	}else {
		navigationBarRightHintImageView.alpha = 1;
	}
}

- (void)setHintWidth: (float) width {
	hintWidth = width;
	[self layoutHintUI];
}

- (void)setSliderEnable:(BOOL)value image:(UIImage *)image
{
	sliderEnable = value;
	if (sliderEnable)
    {
		navigationBarSlider = [[UIImageView alloc] initWithFrame:
							   CGRectMake(hintWidth, 0, unitWidth, self.bounds.size.height)];
        //  CGRectMake(hintWidth, 0, 100, self.bounds.size.height)];
		navigationBarSlider.image = image;
        navigationBarSlider.tag = TAG_SLIDER;
		[navigationBarScrollView addSubview:navigationBarSlider];
	}
    else 
    {
		if (navigationBarSlider != nil) 
        {
			[navigationBarSlider removeFromSuperview];
		}
		navigationBarSlider = nil;
	}
}

- (void)clearAllItems{
    
	[navigationBarItems removeAllObjects];
    [navigationBarButtons removeAllObjects];
    
	while ([navigationBarButtons count] > 0) {
		UIButton *navigationBarLabel = [navigationBarButtons objectAtIndex:0];
		[navigationBarLabel removeFromSuperview];
	}
    for (UIView *view in [navigationBarScrollView subviews]) {
        if (view.tag != TAG_SLIDER) {
            [view removeFromSuperview];
        }
    }
	
}



//- (void)setItems:(NSArray *)items withFont:(UIFont *)font textColor:(UIColor *)color maxScrollSize:(CGSize) maxScrollSize
- (void)setItems:(NSArray *)items withFont:(UIFont *)font textColor:(UIColor *)color
{
    [self clearAllItems];
    
    if (items && [items count]<1) {
        return;
    }
    
    float xPadding = unitPadding;
    float yPadding = sideYPadding;
    
    CGSize maxScrollSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    float contentWidth = 0;
    for (ICNavigationItem * item in items) {
        float uWidth = [item.title sizeWithFont:font].width+xPadding*2;
        contentWidth = contentWidth+uWidth;
    }
        
    //set scrollview's size
	if (contentWidth <= maxScrollSize.width-sideXPadding*2) {
        float x = sideXPadding;
        if (arranageCenter)
            x = (maxScrollSize.width-sideXPadding*2-contentWidth)/2+sideXPadding;
        navigationBarScrollView.frame = CGRectMake(x, sideYPadding, contentWidth, maxScrollSize.height-sideYPadding*2);
	}else {
        navigationBarScrollView.frame = CGRectMake(sideXPadding, sideYPadding, maxScrollSize.width-sideXPadding*2, maxScrollSize.height-sideYPadding*2);
	}
    
    navigationBarBG.frame = CGRectMake(0, sideYPadding, navigationBarScrollView.frame.size.width+sideXPadding*2, navigationBarScrollView.frame.size.height);
    navigationBarFG.frame = CGRectMake(0, sideYPadding, navigationBarScrollView.frame.size.width+sideXPadding*2, navigationBarScrollView.frame.size.height);

//   navigationBarBG.hidden = YES;
//    navigationBarBG.image = [navigationBarBG.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    navigationBarScrollView.contentSize = CGSizeMake(contentWidth, navigationBarScrollView.frame.size.height);
    
    [self layoutHintUI];
    [self setHintImageVisibleAnim:NO];
    
    CGFloat x = 0;
	CGFloat y = 0;
    
    for (int i = 0 ; i < [items count]; i++)
    {
        ICNavigationItem * item = (ICNavigationItem *)[items objectAtIndex:i];
		
        float itemwidth = [item.title sizeWithFont:font].width + xPadding*2;
        float itemHeight = maxScrollSize.height-yPadding*2;
        
		item.index = i;
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.showsTouchWhenHighlighted = NO;
		button.backgroundColor = [UIColor clearColor];
		button.adjustsImageWhenHighlighted = NO;
		
		button.frame = CGRectMake(x,y,itemwidth,itemHeight);
		x = itemwidth +x;
		
		[button setTitle:item.title forState:UIControlStateNormal];
        //button.titleLabel.textAlignment = UITextAlignmentCenter;
		[[button titleLabel] setFont:font];
        if (self.textShadowEnable) {
            button.titleLabel.shadowColor = [UIColor blackColor];
            button.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        }
		[button setTitleColor:color?color:navigationTextColor forState:UIControlStateNormal];
		[button setBackgroundImage:navigationSelectedItemImage forState:UIControlStateSelected];
		//[button setBackgroundImage:navigationSelectedItemImage forState:UIControlStateHighlighted];
		
		[button addTarget:self action:@selector(navigationItemTouchDown:) forControlEvents:UIControlEventTouchUpInside];
		
		[navigationBarScrollView addSubview:button];
		[navigationBarButtons addObject:button];
		[navigationBarItems addObject:item];
    }
    
    _currentIndex = -1;
    [self setCurrentIndex:0 animation:NO];
    
}

-(float)getXByIndex:(float)index{
    
    if (index <-1 || index>= [navigationBarButtons count]) {
        return 0;
    }
    
    float contentWidth = 0;
    
    for (int i=0; i<index; i++) {
        UIButton * button = [navigationBarButtons objectAtIndex:index];
        float uWidth = [button.titleLabel.text sizeWithFont: button.titleLabel.font].width+X_PADDING*2;
        contentWidth = contentWidth+uWidth;
    }
    return contentWidth;
    
}

-(void)setDeSelected:(int)index
{
    if (index <0 || index >= [navigationBarButtons count]) {
        return;
    }
    UIButton *button = [navigationBarButtons objectAtIndex:index];
    [button setTitleColor:navigationTextColor forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setSelected:NO];
}

-(CGRect) targetSliderFrameByIndex:(int)index
{
    if (!sliderEnable) {
        return CGRectZero;
    }
    UIButton *button = [navigationBarButtons objectAtIndex:index];

    if (sliderStyle == ICNavigationBarSliderStyle_UnderGround) {
        float w = [button.titleLabel.text sizeWithFont:button.titleLabel.font].width+unitPadding;
        float x = (button.frame.size.width-w)/2+button.frame.origin.x;
        return CGRectMake(x,button.frame.origin.y, w, button.frame.size.height);
    }else{
        return CGRectMake(button.frame.origin.x+2, button.frame.origin.y+2, button.frame.size.width-4, button.frame.size.height-4);
    }

}

-(void)setCurrentIndex:(float)index animation:(BOOL)animation{
    
	//set default selection
	if (_currentIndex != index && index >-1 && index <[navigationBarButtons count])
    {
        [self setDeSelected:_currentIndex];
        _currentIndex = index;
        
        UIButton *button = [navigationBarButtons objectAtIndex:_currentIndex];
		[[navigationBarButtons objectAtIndex:index] setSelected:YES];
        
		if (navigationSelectedItemImage != nil)
        {
			[button setBackgroundImage:navigationSelectedItemImage forState:UIControlStateSelected];
		}
		if (navigationSelectedTextColor != nil)
        {
            [button setTitleColor:navigationSelectedTextColor forState:UIControlStateNormal];
		}
        
        if (sliderEnable || autoCenterEnable)
        {
            
            void (^block) () = ^() {
                if (sliderEnable)
                {
                    //navigationBarSlider.frame = button.frame;
//                    navigationBarSlider.frame = CGRectMake(button.frame.origin.x+2, button.frame.origin.y+2, button.frame.size.width-4, button.frame.size.height-4);
                    //NSLog(@" button.frame.size.height:%f:", button.frame.size.height);
//                    navigationBarSlider.image = [[UIImage imageNamed:@"navgationbar_slider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                    
                    if (sliderStyle == ICNavigationBarSliderStyle_UnderGround) {
//                        float w = [button.titleLabel.text sizeWithFont:button.titleLabel.font].width;
//                        float x = (button.frame.size.width-w)/2+button.frame.origin.x;
//                        float w = [button.titleLabel.text sizeWithFont:button.titleLabel.font].width+2*unitPadding;
                        float w = [button.titleLabel.text sizeWithFont:button.titleLabel.font].width+unitPadding;
                        float x = (button.frame.size.width-w)/2+button.frame.origin.x;
                        navigationBarSlider.frame = CGRectMake(x,button.frame.origin.y, w, button.frame.size.height);
                    }else{
                        navigationBarSlider.frame = CGRectMake(button.frame.origin.x+2, button.frame.origin.y+2, button.frame.size.width-4, button.frame.size.height-4);
                    }

                    //navigationBarSlider.image = [UIImage imageNamed:@"navgationbar_slider.png"];
                }
                if (autoCenterEnable && navigationBarScrollView.scrollEnabled == YES)
                {
                    float targetX = [self getXByIndex:_currentIndex]+
                    ([button.titleLabel.text sizeWithFont: button.titleLabel.font].width+X_PADDING*2)/2;
                    float centerX = navigationBarScrollView.frame.size.width/2;
                    
                    float finalOffset = 0;
                    
                    if(targetX-centerX>0 && navigationBarScrollView.contentSize.width - targetX >= centerX){
                        finalOffset = targetX-centerX;
                    }
                    else if (targetX-centerX>0 && navigationBarScrollView.contentSize.width - targetX < centerX)
                    {
                        finalOffset = navigationBarScrollView.contentSize.width - navigationBarScrollView.frame.size.width;
                    }
                    [navigationBarScrollView setContentOffset:CGPointMake(finalOffset, 0)];
                }

            };
            
            if (animation) {
                [UIView animateWithDuration:0.2f animations:^{
                    block();
                }];
            }else
            {
                block();
            }
            
//            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//            [UIView setAnimationDuration:0.2f];
//            if (sliderEnable)
//            {
//                navigationBarSlider.frame = button.frame;
//            }
//            if (autoCenterEnable && navigationBarScrollView.scrollEnabled == YES)
//            {   
//                float targetX = [self getXByIndex:_currentIndex]+
//                            ([button.titleLabel.text sizeWithFont: button.titleLabel.font].width+X_PADDING*2)/2;
//                float centerX = navigationBarScrollView.frame.size.width/2;
//                
//                float finalOffset = 0;
//                
//                if(targetX-centerX>0 && navigationBarScrollView.contentSize.width - targetX >= centerX){
//                    finalOffset = targetX-centerX;
//                }
//                else if (targetX-centerX>0 && navigationBarScrollView.contentSize.width - targetX < centerX)
//                {
//                    finalOffset = navigationBarScrollView.contentSize.width - navigationBarScrollView.frame.size.width;
//                }
//                [navigationBarScrollView setContentOffset:CGPointMake(finalOffset, 0)];
//            }
//            [UIView commitAnimations];
        }
        
        if (delegate) {
            [delegate navigationBarItemSelected:_currentIndex from:self];
        }
	}
    
}

- (void) navigationItemTouchDown:(id)sender
{
    [self setCurrentIndex:[navigationBarButtons indexOfObject:sender] animation:YES];
}

/*
- (void) navigationItemTouchDown:(id)sender
{
    if ([sender isSelected])
        return;
    
    if (![sender isSelected]) 
    {
        [sender setSelected:YES];
        UIButton *button = (UIButton *)sender;

        if (navigationSelectedItemImage != nil) 
        {
            [button setBackgroundImage:navigationSelectedItemImage forState:UIControlStateSelected];
        }
        if (navigationSelectedTextColor != nil) 
        {
            //[button setTitleColor:navigationSelectedTextColor forState:UIControlStateSelected];
            [button setTitleColor:navigationSelectedTextColor forState:UIControlStateNormal];
        }
        
        if (sliderEnable || autoCenterEnable) 
        {
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.2f];
            if (sliderEnable) 
            {
                navigationBarSlider.frame = button.frame;
            }
            if (autoCenterEnable) 
            {
                NSInteger index = [navigationBarButtons indexOfObject:button];
                float targetWidth = (index+1)*unitWidth;
                float centerWidth = navigationBarScrollView.frame.size.width/2;
                float finalOffset = 0;
                if(targetWidth-centerWidth>0 && navigationBarScrollView.contentSize.width - targetWidth >= centerWidth){
                    finalOffset = targetWidth-centerWidth;
                }
                else if (targetWidth-centerWidth>0 && navigationBarScrollView.contentSize.width - targetWidth < centerWidth)
                {
                    finalOffset = navigationBarScrollView.contentSize.width - navigationBarScrollView.frame.size.width;
                }
                if (navigationBarScrollView.scrollEnabled)
                {
                    [navigationBarScrollView setContentOffset:CGPointMake(finalOffset, 0)];
                }
            }
            [UIView commitAnimations];
        }
    }

    for (int i=0; i < [navigationBarButtons count]; i++) 
    {    
        UIButton *navigationButton = [navigationBarButtons objectAtIndex:i];
        if (navigationButton == sender) 
        {
            selectedIndex = i;    
            [navigationButton setSelected:YES];
            [delegate performSelector:@selector(navigationBarItemSelected:from:)
                           withObject:(ICNavigationItem *)[navigationBarItems objectAtIndex:i]
                           withObject:self];
        }
        else 
        {
            [navigationButton setTitleColor:navigationTextColor forState:UIControlStateNormal];
            [navigationButton setBackgroundImage:nil forState:UIControlStateNormal];
            [navigationButton setSelected:NO];
        }
    }
}
*/


-(void)setHintImageVisibleAnim:(BOOL)anim
{
    void (^tmp) () = ^() {
        if (navigationBarScrollView.contentOffset.x > 0) {
            navigationBarLeftHintImageView.alpha = 1;
        }else {
            navigationBarLeftHintImageView.alpha = 0;
        }
        
        if (navigationBarScrollView.contentSize.width - navigationBarScrollView.contentOffset.x <= navigationBarScrollView.bounds.size.width) {
            navigationBarRightHintImageView.alpha = 0;
        }else {
            navigationBarRightHintImageView.alpha = 1;
        }
    };
    if (anim) {
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2f];
        tmp();
        [UIView commitAnimations];

    }else{
        tmp();
    }
}



#pragma mark --
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    [self setHintImageVisibleAnim:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */




@end
