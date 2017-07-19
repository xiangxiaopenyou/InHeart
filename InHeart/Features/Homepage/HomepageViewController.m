//
//  HomepageViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/5/27.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageViewController.h"
#import "MyDoctorsViewController.h"
#import "XJDoctorsListViewController.h"
#import "XJVRCenterViewController.h"

#import <UIImage-Helpers.h>
#import <SDCycleScrollView.h>

@interface HomepageViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@property (strong, nonatomic) SDCycleScrollView *cycleView;
@property (strong, nonatomic) UILabel *moreDoctorsLabel;
@property (strong, nonatomic) UIButton *moreDoctorsButton;


@end

@implementation HomepageViewController

#pragma mark - view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topContentView addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topContentView);
    }];
    self.cycleView.imageURLStringsGroup = @[ @"http://img1.3lian.com/img013/v4/57/d/4.jpg"
                                                   , @"http://img1.3lian.com/img013/v4/57/d/7.jpg"
                                                   , @"http://img1.3lian.com/img013/v4/57/d/6.jpg",
                                                   @"http://img1.3lian.com/img013/v4/57/d/8.jpg",
                                                   @"http://img1.3lian.com/img013/v4/57/d/2.jpg"
                                                   ];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.cycleView adjustWhenControllerViewWillAppera];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)itemsAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 100) {
        MyDoctorsViewController *doctorListViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDoctors"];
        [self.navigationController pushViewController:doctorListViewController animated:YES];
    } else if (button.tag == 103) {
        XJVRCenterViewController *vrCenterController = [self.storyboard instantiateViewControllerWithIdentifier:@"VRCenter"];
        [self.navigationController pushViewController:vrCenterController animated:YES];
    }
}
- (void)moreDoctorsAction {
    XJDoctorsListViewController *doctorsListController = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorsList"];
    [self.navigationController pushViewController:doctorsListController animated:YES];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 40.f : 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"MoreDoctorsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = XJSystemFont(15);
        cell.textLabel.textColor = MAIN_TEXT_COLOR;
        cell.textLabel.text = @"推荐医生";
        [cell.contentView addSubview:self.moreDoctorsLabel];
        [self.moreDoctorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(0);
            make.centerY.equalTo(cell.contentView);
        }];
        [cell.contentView addSubview:self.moreDoctorsButton];
        [self.moreDoctorsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(cell.contentView);
            make.width.equalTo(cell.contentView.mas_width).with.multipliedBy(0.3);
        }];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        return cell;
    }
}

#pragma mark - Getters
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[SDCycleScrollView alloc] init];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleView.autoScrollTimeInterval = 5.0;
        _cycleView.currentPageDotColor = NAVIGATIONBAR_COLOR;
        _cycleView.pageDotColor = [UIColor whiteColor];
        _cycleView.delegate = self;
    }
    return _cycleView;
}
- (UILabel *)moreDoctorsLabel {
    if (!_moreDoctorsLabel) {
        _moreDoctorsLabel = [[UILabel alloc] init];
        _moreDoctorsLabel.text = @"更多";
        _moreDoctorsLabel.textColor = XJHexRGBColorWithAlpha(0x999999, 1);
        _moreDoctorsLabel.font = XJSystemFont(12);
    }
    return _moreDoctorsLabel;
}
- (UIButton *)moreDoctorsButton {
    if (!_moreDoctorsButton) {
        _moreDoctorsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreDoctorsButton addTarget:self action:@selector(moreDoctorsAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreDoctorsButton;
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
