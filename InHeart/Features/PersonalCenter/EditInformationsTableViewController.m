
//
//  EditInformationsTableViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EditInformationsTableViewController.h"

#import "UserAddressCell.h"

#import <Masonry.h>

@interface EditInformationsTableViewController ()<UITextFieldDelegate>
@property (copy, nonatomic) NSArray *itemsArray;
@property (copy, nonatomic) NSString *addressString;

@end

@implementation EditInformationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    
    _itemsArray = @[kName, kIdCardNumber, kAge, kEmergencyContactPerson, kEmergencyContactPhone];
    _addressString = @"浙江";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        CGSize size = XLSizeOfText(_addressString, SCREEN_WIDTH - 140, kSystemFont(14));
        return size.height + 38.0;
    } else {
        return 46.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        UserAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserAddress" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.text = _addressString;
        cell.editBlock = ^(NSString *string){
            _addressString = string;
            [tableView beginUpdates];
            [tableView endUpdates];
        };
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = kSystemFont(15);
        cell.textLabel.textColor = MAIN_TEXT_COLOR;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", _itemsArray[indexPath.row]];
        UITextField *textField = [[UITextField alloc] init];
        textField.font = kSystemFont(14);
        textField.textColor = TABBAR_TITLE_COLOR;
        textField.tag = 100 + indexPath.row;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView).with.mas_offset(120);
            make.trailing.equalTo(cell.contentView).with.mas_offset(-15);
            make.top.bottom.equalTo(cell.contentView);
        }];
        if (indexPath.row == 2 || indexPath.row == 4) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3) {
            textField.returnKeyType = UIReturnKeyNext;
        }
        return cell;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
- (IBAction)saveAction:(id)sender {
}

@end