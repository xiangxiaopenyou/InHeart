
//
//  ExpertDetailViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/22.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ExpertDetailViewController.h"

#import "ExpertNameCell.h"
#import "ExpertIntroductionCell.h"

#import "DoctorModel.h"
#import "UserInfo.h"

#import <UIImageView+AFNetworking.h>
#import <GJCFUitils.h>

@interface ExpertDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *consultationNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *consultationPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@end

@implementation ExpertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isChatting) {
        self.bottomViewHeightConstraint.constant = 0;
    }
    [self resetContentsViews];
    [self fetchDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request
- (void)fetchDetail {
    XLShowHUDWithMessage(nil, self.view);
    [DoctorModel fetchDoctorDetail:self.doctorModel.id handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.doctorModel = object;
            GJCFAsyncMainQueue(^{
                [self resetContentsViews];
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Private Methods
- (void)resetContentsViews {
    [self.photoView setImageWithURL:XLURLFromString(self.doctorModel.photo) placeholderImage:[UIImage imageNamed:@"default_image"]];
    if (!XLIsNullObject(self.doctorModel.consultationTimes)) {
        [self.consultationNumberButton setTitle:[NSString stringWithFormat:@"%@人咨询过", self.doctorModel.consultationTimes] forState:UIControlStateNormal];
    } else {
        [self.consultationNumberButton setTitle:@"0人咨询过" forState:UIControlStateNormal];
    }
    if (self.doctorModel.minPrice) {
        self.consultationPriceLabel.text = [NSString stringWithFormat:@"咨询费：￥%@", self.doctorModel.minPrice];
    } else {
        self.consultationPriceLabel.text = [NSString stringWithFormat:@"咨询费：￥0"];
    }
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 44.0;
    } else {
        NSString *introductionString = self.doctorModel.introduction;
        if (XLIsNullObject(introductionString)) {
            introductionString = @"暂无介绍";
        }
        CGSize introductionSize = XLSizeOfText(introductionString, SCREEN_WIDTH - 30.0, XJSystemFont(13));
        height = 112 + introductionSize.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ExpertNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertName" forIndexPath:indexPath];
        cell.nameLabel.text = XLIsNullObject(self.doctorModel.realname) ? @"未知姓名" : [NSString stringWithFormat:@"%@", self.doctorModel.realname];
        cell.levelLabel.text = XLIsNullObject(self.doctorModel.title) ? nil : [NSString stringWithFormat:@"%@", self.doctorModel.title];
        return cell;
    } else {
        ExpertIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertIntroduction" forIndexPath:indexPath];
        cell.introductionContentLabel.text = XLIsNullObject(self.doctorModel.introduction) ? @"暂无介绍" : [NSString stringWithFormat:@"%@", self.doctorModel.introduction];
        cell.clickAttentionButton.selected = [self.doctorModel.isCollect integerValue] == 0 ? NO : YES;
        GJCFWeakObject(ExpertIntroductionCell *) weakCell = cell;
        cell.attentionBlock = ^(){
            GJCFStrongObject(ExpertIntroductionCell *)strongCell = weakCell;
            if ([self.doctorModel.isCollect integerValue] == 0) {
                self.doctorModel.isCollect = @1;
                strongCell.clickAttentionButton.selected = YES;
                [DoctorModel addAttention:self.doctorModel.id handler:nil];
            } else {
                self.doctorModel.isCollect = @0;
                strongCell.clickAttentionButton.selected = NO;
                [DoctorModel cancelAttention:self.doctorModel.id handler:nil];
            }
        };
        return cell;
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
- (IBAction)consultAction:(id)sender {
    if (![[UserInfo sharedUserInfo] shouldLogin:self]) {
//        ConversationModel *tempModel = [ConversationModel new];
//        tempModel.userId = self.doctorModel.id;
//        tempModel.realname = self.doctorModel.realname;
//        ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:self.doctorModel.mobile conversationType:EMConversationTypeChat];
//        chatViewController.hidesBottomBarWhenPushed = YES;
//        chatViewController.conversationModel = tempModel;
//        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

@end
