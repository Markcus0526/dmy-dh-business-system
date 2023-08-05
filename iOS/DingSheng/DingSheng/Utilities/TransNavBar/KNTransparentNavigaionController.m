//
//  KNTransparentNavigaionController.m
//  Goal
//
//  Created by Jianying Shi on 8/17/14.
//
//

#import "KNTransparentNavigaionController.h"
#import "UIImage+ImageEffects.h"

@interface KNTransparentNavigaionController ()

@end

@implementation KNTransparentNavigaionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initNavBar];
    }
    return self;
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}
- (void) initNavBar{
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"TransNavBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
  
//    self.navigationBar.tintColor = [self colorWithHexString:@"#555555"];
   
    //TODO back and signin size 34 font family Whitney
    // CENTER THEXT 46 Brandon Gotesque
/*
    UIFont * font = [UIFont fontWithName:@"Brandon Grotesque" size:23];
    [self.navigationBar setTitleTextAttributes :@{
                                                  NSFontAttributeName:font,
                                                  NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:1]
                                                  }];
  */

}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self initNavBar];
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

@end
