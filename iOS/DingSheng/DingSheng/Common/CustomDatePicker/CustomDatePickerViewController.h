//
//  CustomDatePickerViewController.h
//  DingSheng
//
//  Created by Kim Ok Chol on 11/2/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDelegate <NSObject>

@optional
- (void) didChangedCustomDatePicker : (BOOL)changed date:(NSString *)date;

@end

@interface CustomDatePickerViewController : UIViewController

@property(strong, nonatomic) id<CustomDatePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)onTapCancel:(id)sender;
- (IBAction)onTapConfirm:(id)sender;


@end
