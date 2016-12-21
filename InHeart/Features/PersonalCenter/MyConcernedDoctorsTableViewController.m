//
//  MyConcernedDoctorsTableViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MyConcernedDoctorsTableViewController.h"

#import "ConcernedDoctorCell.h"

#import "DoctorModel.h"

#import <UIImageView+WebCache.h>

@interface MyConcernedDoctorsTableViewController ()

@property (copy, nonatomic) NSArray *doctorsArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation MyConcernedDoctorsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    
    [self fetchConcernedDoctors];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

#pragma mark - Requests
- (void)fetchConcernedDoctors {
    XLShowHUDWithMessage(nil, self.view);
    [DoctorModel fetchConcernedDoctors:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            _doctorsArray = [object copy];
            [self.tableView reloadData];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _doctorsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConcernedDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConcernedCell" forIndexPath:indexPath];
    DoctorModel *tempModel = _doctorsArray[indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:XLURLFromString(tempModel.headPictureUrl) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
    cell.nameLabel.text = XLIsNullObject(tempModel.realname) ? nil : [NSString stringWithFormat:@"%@", tempModel.realname];
    cell.nameLabelTopConstraint.constant = XLIsNullObject(tempModel.region) ? 30 : 15;
    cell.cityLabel.text = XLIsNullObject(tempModel.region) ? nil : [NSString stringWithFormat:@"%@", tempModel.region];
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
