//
//  PersonalCenterViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "SystemSettingTableViewController.h"
#import "MyDoctorsViewController.h"

@interface PersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (copy, nonatomic) NSArray *itemTitlesArray;
@property (copy, nonatomic) NSArray *itemIconsArray;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)couponAction:(id)sender {
}
- (IBAction)pointsAction:(id)sender {
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
        case 3:
            number = 3;
            break;
        default:
            break;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = kSystemFont(15);
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.itemTitlesArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"personal_center_icon0"];
        }
            break;
        case 1: {
            cell.textLabel.text = self.itemTitlesArray[indexPath.row + 1];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"personal_center_icon%@", @(indexPath.row + 1)]];
        }
            break;
        case 2: {
            cell.textLabel.text = self.itemTitlesArray[indexPath.row + 4];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"personal_center_icon%@", @(indexPath.row + 4)]];
        }
            break;
        case 3: {
            cell.textLabel.text = self.itemTitlesArray[indexPath.row + 6];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"personal_center_icon%@", @(indexPath.row + 6)]];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:{
            if (indexPath.row == 0) {
                MyDoctorsViewController *doctorListViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDoctors"];
                [self.navigationController pushViewController:doctorListViewController animated:YES];
            }
        }
            break;
        case 2:{
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                SystemSettingTableViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemSetting"];
                [self.navigationController pushViewController:settingViewController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    return headerView;
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat y = scrollView.contentOffset.y;
        if (y > 0) {
            self.topViewHeightConstraint.constant = 230.f;
            self.topViewTopConstraint.constant = - y;
        } else {
            self.topViewHeightConstraint.constant = 230.f - y;
            self.topViewTopConstraint.constant = 0;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - getters
- (NSArray *)itemTitlesArray {
    if (!_itemTitlesArray) {
        _itemTitlesArray = [NSArray arrayWithObjects:NSLocalizedString(@"personal.myOrder", nil), NSLocalizedString(@"personal.myDoctors", nil), NSLocalizedString(@"personal.myAppointments", nil), NSLocalizedString(@"personal.consultionRecord", nil), NSLocalizedString(@"personal.myCollections", nil), NSLocalizedString(@"personal.myEvaluation", nil), NSLocalizedString(@"personal.setting", nil), NSLocalizedString(@"personal.feedback", nil), NSLocalizedString(@"personal.recommend", nil), nil];
    }
    return _itemTitlesArray;
}

@end
