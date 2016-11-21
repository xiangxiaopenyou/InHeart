//
//  PersonalCenterTableViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalCenterTableViewController.h"
#import "LoginViewController.h"
#import "SystemSettingTableViewController.h"
#import "EditInformationsTableViewController.h"
#import "PersonalInformationCell.h"
#import "CommonFunctionCell.h"

#import "UserInfo.h"
#import "UserModel.h"
#import "PersonalInfo.h"

@interface PersonalCenterTableViewController ()
@property (strong, nonatomic) UserModel *userModel;

@end

@implementation PersonalCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userModel = [[UserInfo sharedUserInfo] userInfo];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 3;
            break;
        case 2:
            number = 2;
            break;
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            PersonalInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"personal_avatar"];
            if (![[UserInfo sharedUserInfo] isLogined]) {
                cell.textLabel.text = @"尚未登录";
                cell.detailTextLabel.text = @"点击登录";
            } else {
                if ([self.userModel.username isEqualToString:self.userModel.realname]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.userModel.username];
                    cell.detailTextLabel.text = nil;
                } else {
                    if (XLIsNullObject(self.userModel.realname)) {
                        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.userModel.username];
                        cell.detailTextLabel.text = nil;
                    } else {
                        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.userModel.realname];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userModel.username];
                    }
                }
            }
            
            return cell;
        }
            break;
        case 1:{
            CommonFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonFunction" forIndexPath:indexPath];
            NSArray *tempIconArray = @[@"my_prescriptions", @"my_collections", @"my_account"];
            NSArray *tempTitleArray = @[kMyPrescriptions, kMyAttention, kMyAccount];
            cell.imageView.image = [UIImage imageNamed:tempIconArray[indexPath.row]];
            cell.textLabel.font = kSystemFont(15);
            cell.textLabel.textColor = MAIN_TEXT_COLOR;
            cell.textLabel.text = tempTitleArray[indexPath.row];
            
            return cell;
        }
            break;
        case 2:{
            CommonFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonFunction" forIndexPath:indexPath];
            NSString *iconString;
            NSString *titleString;
            if (indexPath.row == 0) {
                iconString = @"help_feedback";
                titleString = kHelpAndFeedback;
            } else {
                iconString = @"setting";
                titleString = kPersonalSetting;
            }
            cell.imageView.image = [UIImage imageNamed:iconString];
            cell.textLabel.font = kSystemFont(15);
            cell.textLabel.textColor = MAIN_TEXT_COLOR;
            cell.textLabel.text = titleString;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (![[UserInfo sharedUserInfo] shouldLogin:self]) {
            EditInformationsTableViewController *informationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditInformations"];
            [self.navigationController pushViewController:informationViewController animated:YES];
        }
        
    } else if (indexPath.section == 1) {
        
    } else {
        if ( indexPath.row == 0) {
            
        } else {
            SystemSettingTableViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemSetting"];
            [self.navigationController pushViewController:settingViewController animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70.0;
    } else {
        return 45.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *headerLabel = [UILabel new];
//    return headerLabel;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
