//
//  UIPCNavigationBar.h
//  sandscreen
//
//  Created by liuyang on 11-4-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ICNavigationBarSliderStyle_InCase,
    ICNavigationBarSliderStyle_UnderGround
}ICNavigationBarSliderStyle;


@interface ICNavigationItem : NSObject {
    
	NSString *			title;
	UIImage	*			image;
	NSInteger			index;
}
@property (nonatomic,strong) NSString *			title;
@property (nonatomic,strong) UIImage *			image;
@property (nonatomic) NSInteger					index;

@end

@protocol ICNavigationBarDelegate
@required
//- (void) navigationBarItemSelected:(ICNavigationItem*)item from:(id)sender;
- (void) navigationBarItemSelected:(int)index from:(id)sender;
@end

@interface ICNavigationBar : UIView <UIScrollViewDelegate>{

	UIImageView	*           navigationBarLeftHintImageView;
	UIImageView	*			navigationBarRightHintImageView;
	UIImageView *			navigationBarSlider;
    UIImageView *			navigationBarBG;
    UIImageView *			navigationBarFG;
	UIImage *				navigationSelectedItemImage;
	UIColor *				navigationSelectedTextColor;
	UIColor *               navigationTextColor;
	//UIPCScrollView *		navigationBarScrollView;
    UIScrollView *          navigationBarScrollView;
	NSMutableArray *		navigationBarItems;
	NSMutableArray *		navigationBarButtons;
	
	BOOL					autoCenterEnable;
	BOOL					sliderEnable;
    BOOL					textShadowEnable;
    BOOL					arranageCenter;

	
	float					hintWidth;
	float					unitWidth;
    
    float                   sideXPadding;
    float                   sideYPadding;
    float                   unitPadding;

	
	int						selectedIndex;
    ICNavigationBarSliderStyle                  sliderStyle;
    id<ICNavigationBarDelegate>					delegate;

}

@property (strong, nonatomic ,readonly) UIImageView *			navigationBarLeftHintImageView;
@property (strong, nonatomic ,readonly) UIImageView *			navigationBarRightHintImageView;
@property (strong, nonatomic ,readonly) UIImageView *			navigationBarBG;
@property (strong, nonatomic ,readonly) UIImageView *			navigationBarFG;
@property (nonatomic ,strong) UIImage *				navigationSelectedItemImage;
@property (nonatomic ,strong) UIColor *				navigationSelectedTextColor;
@property (nonatomic ,strong) UIColor *				navigationTextColor;
@property (strong, nonatomic ,readonly) UIImageView *			navigationBarSlider;
@property (nonatomic ,readonly) NSMutableArray *		navigationBarItems;
//@property (nonatomic ,retain) UIPCScrollView *		navigationBarScrollView;
@property (strong, nonatomic ,readonly) UIScrollView *		navigationBarScrollView;
@property (strong)	id<ICNavigationBarDelegate>		delegate;
@property (assign)	int								selectedIndex;
@property (assign)  BOOL                            textShadowEnable;
@property (assign)  ICNavigationBarSliderStyle      sliderStyle;
@property (assign)  BOOL                            arranageCenter;
@property (assign)  float                           sideXPadding;
@property (assign)  float                           sideYPadding;
@property (assign)  float                           unitPadding;






- (id)initWithFrame:(CGRect)frame autoCenter:(BOOL)value;
- (void)layoutHintUI;
- (void)layoutForOrientation:(CGRect)size;
- (void)setHintWidth: (float) width;

- (CGRect) targetSliderFrameByIndex:(int)index;

//- (void)setItems:(NSArray *)items withFont:(UIFont *)font textColor:(UIColor *)color unitWidth:(float)width;
- (void)setItems:(NSArray *)items withFont:(UIFont *)font textColor:(UIColor *)color;
//- (void)setItems:(NSArray *)items withFont:(UIFont *)font textColor:(UIColor *)color maxScrollSize:(CGSize) maxScrollSize;

//- (void)setItemsForIpad:(NSArray *)items withFont:(UIFont *)font textColor:(UIColor *)color unitWidth:(float)width;
- (void)setSliderEnable:(BOOL)value image:(UIImage *)image;
- (void)clearAllItems;
- (void) navigationItemTouchDown:(id)sender;

-(void)setCurrentIndex:(float)index animation:(BOOL)animation;



@end
