//
//  XJVRCenterViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/7/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJVRCenterViewController.h"
#import "XJVRRoomCell.h"

@interface XJVRCenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortTableViewHeigit;

@property (copy, nonatomic) NSArray *sortArray;
@property (nonatomic) BOOL isSortViewOpened;
@property (nonatomic) NSInteger seletedSortIndex;

@end

@implementation XJVRCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)areaAction:(id)sender {
}
- (IBAction)sortAction:(id)sender {
    _isSortViewOpened = !_isSortViewOpened;
    [self sortViewChanged];
}
- (IBAction)sortViewAction:(id)sender {
    _isSortViewOpened = NO;
    [self sortViewChanged];
}

#pragma mark - Private methods
- (void)sortViewChanged {
    if (_isSortViewOpened) {
        self.sortView.hidden = NO;
        self.sortTableViewHeigit.constant = 120.f;
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            [self.view layoutIfNeeded];
        }];
    } else {
        self.sortTableViewHeigit.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowImage.transform = CGAffineTransformMakeRotation(0);
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.sortView.hidden = YES;
        }];
    }
    [self.sortButton setTitle:self.sortArray[_seletedSortIndex] forState:UIControlStateNormal];
    if (_seletedSortIndex > 0) {
        [self.sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sortButton.titleLabel.font = XJBoldSystemFont(14);
    } else {
        [self.sortButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.sortButton.titleLabel.font  = XJSystemFont(14);
    }
}

#pragma mark - Table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.tag == 111 ? 3 : 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.tag == 111 ? 40.f : 120.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 111) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = MAIN_TEXT_COLOR;
        cell.textLabel.font = XJSystemFont(15);
        cell.textLabel.text = self.sortArray[indexPath.row];
        if (indexPath.row == _seletedSortIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = NAVIGATIONBAR_COLOR;
        }
        return cell;
    } else {
        static NSString *identifier = @"VRRoomCell";
        XJVRRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 111) {
        _seletedSortIndex = indexPath.row;
        [tableView reloadData];
        _isSortViewOpened = NO;
        [self sortViewChanged];
    }
}

#pragma mark - Getters
- (NSArray *)sortArray {
    if (!_sortArray) {
        _sortArray = @[@"全部分类", @"综合", @"移动"];
    }
    return _sortArray;
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
