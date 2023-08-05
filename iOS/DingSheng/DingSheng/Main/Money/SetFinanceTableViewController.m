//
//  SetFinanceTableViewController.m
//  DingSheng
//
//  Created by Kim Ok Chol on 10/30/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "SetFinanceTableViewController.h"

@interface SetFinanceTableViewController ()

@end

@implementation SetFinanceTableViewController

@synthesize mCurSvcMode;
@synthesize mCardId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



///////////////////////////////////////////////////////////////////////////
#pragma mark - Basic Function

/**
 * Initilaize all ui controls & member variable
 */
- (void) initControls
{
    
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - Web Service Relation

/**
 * call add service item
 */
- (void) callAddServiceItem : (NSString *)cardno name:(NSString *)name phonenum:(NSString *)phonenum identino:(NSString *)identino
                     address:(NSString *)address note:(NSString *)note
{
    [SVProgressHUD showWithStatus:MSG_PLEASE_WAIT maskType:SVProgressHUDMaskTypeClear];
    
    TEST_NETWORK_RETURN;
    
    [[CommManager getCommMgr] financeSvcMgr].delegate = self;
    [[[CommManager getCommMgr] financeSvcMgr] AddServiceItem:[Common userId] mode:mCurSvcMode cardno:cardno name:name phonenum:phonenum identino:identino address:address note:note];
}

- (void) addServiceItemResult:(NSInteger)result
{
    if (result == SVCERR_SUCCESS) {
        
        [SVProgressHUD dismiss];
        // go to success
        [self performSegueWithIdentifier:@"segueFromSetFinanceToSuccess" sender:nil];
    }
    else
    {
        NSString * msg = [CommManager getRetMsg:result];
        [SVProgressHUD dismissWithError:msg afterDelay:DEF_DELAY];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark - UI Event

- (IBAction)onTapConfirm:(id)sender
{
    if ([NSString isNullOrEmpty:[_txtCardName text]])
    {
        [_txtCardName becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtPhone text]]) {
        [_txtPhone becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtAuthCode text]]) {
        [_txtAuthCode becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtAddress text]]) {
        [_txtAddress becomeFirstResponder];
        return;
    }
    if ([NSString isNullOrEmpty:[_txtNotice text]]) {
        [_txtNotice becomeFirstResponder];
        return;
    }
    
    [self callAddServiceItem:[NSString stringWithFormat:@"%ld", mCardId] name:[_txtCardName text] phonenum:[_txtPhone text] identino:[_txtAuthCode text] address:[_txtAddress text] note:[_txtNotice text]];
}

@end
