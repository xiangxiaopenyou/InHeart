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
#import "XJChatViewController.h"

#import "XJRecommendedDoctorCell.h"

#import "DoctorModel.h"

#import <UIImage-Helpers.h>
#import <SDCycleScrollView.h>

@interface HomepageViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@property (strong, nonatomic) SDCycleScrollView *cycleView;
@property (strong, nonatomic) UILabel *moreDoctorsLabel;
@property (strong, nonatomic) UIButton *moreDoctorsButton;

@property (copy, nonatomic) NSArray *doctorsArray;


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
    [self recommendedDoctorsListRequest];
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

#pragma mark - request
- (void)recommendedDoctorsListRequest {
    [DoctorModel fetchDoctorsList:nil region:nil disease:nil paging:@0 handler:^(id object, NSString *msg) {
        if (object) {
            self.doctorsArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doctorsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJRecommendedDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedDoctorCell" forIndexPath:indexPath];
    DoctorModel *tempModel = self.doctorsArray[indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:XLURLFromString(tempModel.headPictureUrl) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
    cell.nameLabel.text = tempModel.realname;
    cell.titleLabel.text = tempModel.title ? tempModel.title : nil;
    cell.hospitalLabel.text = tempModel.hospital ? tempModel.hospital : @"未知医院";
    cell.expertiseLabel.text = tempModel.expertise ? [NSString stringWithFormat:@"擅长：%@", tempModel.expertise] : @"擅长：未知";
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.f)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"推荐医生";
    headerLabel.font = XJSystemFont(15);
    headerLabel.textColor = MAIN_TEXT_COLOR;
    [headerView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView.mas_leading).with.mas_offset(15);
        make.centerY.equalTo(headerView);
    }];
    [headerView addSubview:self.moreDoctorsButton];
    [self.moreDoctorsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(headerView);
        make.width.mas_offset(100);
    }];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ConversationModel *tempModel = [[ConversationModel alloc] init];
    DoctorModel *doctorModel = self.doctorsArray[indexPath.row];
//    tempModel.userId = doctorModel.id;
//    tempModel.realname = doctorModel.realname;
//    tempModel.avatarUrl = doctorModel.headPictureUrl;
    XJChatViewController *chatViewController = [[XJChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:doctorModel.id];
    chatViewController.conversationType = ConversationType_PRIVATE;
    chatViewController.targetId = doctorModel.id;
    chatViewController.title = doctorModel.realname;
    chatViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatViewController animated:YES];
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
- (UIButton *)moreDoctorsButton {
    if (!_moreDoctorsButton) {
        _moreDoctorsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreDoctorsButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreDoctorsButton setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        _moreDoctorsButton.titleLabel.font = XJSystemFont(15);
        [_moreDoctorsButton setImage:[UIImage imageNamed:@"more_news"] forState:UIControlStateNormal];
        [_moreDoctorsButton addTarget:self action:@selector(moreDoctorsAction) forControlEvents:UIControlEventTouchUpInside];
        [_moreDoctorsButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 90)];
        [_moreDoctorsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - 20, 0, 0)];
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
