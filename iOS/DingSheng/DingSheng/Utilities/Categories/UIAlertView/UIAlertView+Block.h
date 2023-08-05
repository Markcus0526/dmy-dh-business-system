//
//  UIAlertView+Block.h

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
