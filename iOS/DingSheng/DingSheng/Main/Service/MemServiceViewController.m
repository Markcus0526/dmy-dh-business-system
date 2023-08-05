//
//  MemServiceViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/29/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "MemServiceViewController.h"
#import "RDActionSheet.h"
#import "NonRotateImagePickerController.h"
#import "ImageHelper.h"

@interface MemServiceViewController ()

@end

@implementation MemServiceViewController

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
    
    [self initControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    mUserImgData = @"";
    
    [self callGetUserInfo];
}

- (void) updateUI
{
    // set user image
    UIImage * defImage = [UIImage imageNamed:@"ic_stub.png"];
    NSString * imgurl = [NSString stringWithFormat:@"%@%@", [Common baseUrl], mUserInfo.imgpath];
    [_imgUser setImageWithURL:[NSURL URLWithUnicodeString:imgurl] placeholderImage:defImage];
    // set user accum
    [_lblAccum setText:[NSString stringWithFormat:@"%@的积分：%ld", mUserInfo.username, (long)mUserInfo.credit]];
    // set extra info
    [_lblNickName setText:mUserInfo.userid];
    [_txtRealName setText:mUserInfo.username];
    [_lblBirthday setText:mUserInfo.birth];
    [_txtEmail setText:mUserInfo.email];
    [_lblMyOrders setText:[NSString stringWithFormat:@"%ld笔", (long)mUserInfo.ordercount]];
    [_txtPhoneNum setText:mUserInfo.phonenum];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call get user info service
 */
- (void) callGetUserInfo
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] GetUserInfo:[Common userId]];
}

- (void) getUserInfoResult:(NSInteger)result datainfo:(STUserInfo *)datainfo
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // set data info to ui
        mUserInfo = datainfo;
        [self updateUI];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}

/**
 * call get user info service
 */
- (void) callUpdateUserInfo : (NSString *)username birthday:(NSString *)birthday email:(NSString *)email phonenum:(NSString *)phonenum
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] accountSvcMgr].delegate = self;
    [[[CommManager getCommMgr] accountSvcMgr] UpdateUserInfo:[Common userId] username:username birthday:birthday email:email phonenum:phonenum imgdata:mUserImgData];
}

- (void) updateUserInfoResult:(NSInteger)result
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismissWithSuccess:MSG_SUCCESS afterDelay:DEF_DELAY];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - Custom Date Picker Delegate
- (void) didChangedCustomDatePicker:(BOOL)changed date:(NSString *)date
{
    if (changed) {
        [_lblBirthday setText:date];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - UI Event

- (IBAction)onTapImage:(id)sender
{
    RDActionSheet *actionSheet = [RDActionSheet alloc];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet initWithCancelButtonTitle:@"取消"
                            primaryButtonTitle:nil
                            destroyButtonTitle:nil
                             otherButtonTitles:@"相册", @"拍照", nil];
    }
    else {
        [actionSheet initWithCancelButtonTitle:@"取消"
                            primaryButtonTitle:nil
                            destroyButtonTitle:nil
                             otherButtonTitles:@"相册",nil];
    }
    actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) {
        
        switch (result) {
            case RDActionSheetButtonResultSelected:
            {
                NSLog(@"Pressed %i", buttonIndex);
                
                UIImagePickerController *picker = [[NonRotateImagePickerController alloc] init];
                //                picker.delegate = [HuiYuanZhongXinViewController sharedInstance];
                picker.delegate = self;
                picker.allowsEditing = YES;
                
                if (buttonIndex == 0)
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                else
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    //picker.modalInPopover = YES;
                    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                    //                    popover.delegate = [HuiYuanZhongXinViewController sharedInstance];
                    popover.delegate = self;
                    [popover presentPopoverFromRect:CGRectMake(90, 150, 270, 300)
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionLeft
                                           animated:YES];
                    //[popover setPopoverContentSize:CGSizeMake(500, 500)];
                } else {
                    [self presentModalViewController:picker animated:YES];
                }
                break;
            }
            case RDActionSheetResultResultCancelled:
                NSLog(@"Sheet cancelled");
                break;
        }
    };
    [actionSheet showFrom:self.view];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerEditedImage];
	UIImage *orgImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (srcImage == nil)
        srcImage = orgImage;
    
    //UIImage *image = [srcImage imageByScalingAndCroppingForSize:CGSizeMake(128, 128)];
    UIImage * image = srcImage;
    
    if (image != nil)
    {
        [_imgUser setImage:image];
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSString * base64Image = [GlobalFunc base64forData:data];
        
        mUserImgData = base64Image;
    }
    else
	{
        NSString * result = STRING_DATAMANAGER_PHOTOSIZE;
        [self.view makeToast:result duration:DEF_DELAY position:@"center"];
	}
	
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

/**
 * Birthday click event
 */
- (IBAction)onTapBirthday:(id)sender
{
    CustomDatePickerViewController *viewController = (CustomDatePickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CustomDatePicker"];
    viewController.delegate = self;
    viewController.view.backgroundColor = [UIColor clearColor];
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:viewController animated:YES completion:nil];
}

/**
 * Clicked Confirm button event
 */
- (IBAction)onTapConfirm:(id)sender
{
    if ([NSString isNullOrEmpty:[_txtRealName text]]) {
        [_txtRealName becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtEmail text]]) {
        [_txtEmail becomeFirstResponder];
        return;
    }
    
    [self callUpdateUserInfo:[_txtRealName text] birthday:[_lblBirthday text] email:[_txtEmail text] phonenum:[_txtPhoneNum text]];
}
@end
