//
//  SuccessFinanceViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 11/2/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "SuccessFinanceViewController.h"
#import "FinanSubMenuViewController.h"

@interface SuccessFinanceViewController ()

@end

@implementation SuccessFinanceViewController

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

- (IBAction)onTapConfirm:(id)sender
{
    for (UIViewController * ctrl in self.navigationController.viewControllers) {
        if ([ctrl isKindOfClass:[FinanSubMenuViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
}
@end
