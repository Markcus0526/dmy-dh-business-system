//
//  CustomDatePickerViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/2/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "CustomDatePickerViewController.h"

@interface CustomDatePickerViewController ()

@end

@implementation CustomDatePickerViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTapCancel:(id)sender
{
    NSDate *selected = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    [delegate didChangedCustomDatePicker:NO date:destDateString];
    
    // dismiss current view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapConfirm:(id)sender
{
    NSDate *selected = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    [delegate didChangedCustomDatePicker:YES date:destDateString];
    
    // dismiss current view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
