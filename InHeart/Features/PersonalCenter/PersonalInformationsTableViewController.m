//
//  PersonalInformationsTableViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/15.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PersonalInformationsTableViewController.h"
#import "InformationEditingViewController.h"
#import "UserAvatarCell.h"

#import "XLBlockActionSheet.h"

@interface PersonalInformationsTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (copy, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UIImage *resultImage;

@end

@implementation PersonalInformationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)presentImagePickerController:(NSInteger)index {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = index == 1 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)pushToInformationEditView:(XJInformationType)type {
    InformationEditingViewController *editingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationEditing"];
    editingViewController.type = type;
    [self.navigationController pushViewController:editingViewController animated:YES];
}

#pragma mark - Image picker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _resultImage = info[@"UIImagePickerControllerEditedImage"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row == 0 ? 90.f : 45.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             static NSString *identifier = @"AvatarCell";
            UserAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.avatarLabel.text = self.titleArray[indexPath.row];
            if (_resultImage) {
                cell.avatarImageView.image = _resultImage;
            } else if ([[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING]) {
                NSString *avatarUrlString = [[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING];
                [cell.avatarImageView sd_setImageWithURL:XLURLFromString(avatarUrlString) placeholderImage:nil];
            }
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInformationCell" forIndexPath:indexPath];
            cell.textLabel.text = self.titleArray[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInformationCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.titleArray[indexPath.row + 4];
        NSString *phoneString = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", phoneString];
        return cell;
    }
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1 || buttonIndex == 2) {
                        [self presentImagePickerController:buttonIndex];
                    }
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil] showInView:self.view];
            }
                break;
            case 1: {
                [self pushToInformationEditView:XJInformationTypeName];
            }
                break;
            case 2:{
                [self pushToInformationEditView:XJInformationTypeSex];
            }
                break;
            case 3:{
                [self pushToInformationEditView:XJInformationTypeAge];
            }
                break;
            default:
                break;
        }
    }
}

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

#pragma mark - getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"personal.avatar", nil), NSLocalizedString(@"personal.name", nil), NSLocalizedString(@"personal.sex", nil), NSLocalizedString(@"personal.age", nil), NSLocalizedString(@"personal.phoneNumber", nil), NSLocalizedString(@"personal.changePassword", nil), nil];
    }
    return _titleArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
