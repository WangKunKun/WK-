

#import <UIKit/UIKit.h>
@class WKDatePickView;
typedef void (^AddressChoicePickerViewBlock)(WKDatePickView *view,NSString * date);//16/03/04 10:10
@interface WKDatePickView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock block;

- (void)show;
@end
