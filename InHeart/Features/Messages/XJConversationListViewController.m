//
//  XJConversationListViewController.m
//  InHeart
//
//  Created by 项小盆友 on 2017/12/4.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJConversationListViewController.h"
#import "XJChatViewController.h"
#import "XJChatListCell.h"

#import "UserMessageModel.h"
#import "XJPlanOrderMessage.h"
#import "XJDataBase.h"

@interface XJConversationListViewController ()
@property (strong, nonatomic) UILabel *emptyLabel;
@end

@implementation XJConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    [self setDisplayConversationTypes:@[
                                        @(ConversationType_PRIVATE)
                                        ]];
    self.showConnectingStatusOnNavigatorBar = YES;
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.separatorColor = BREAK_LINE_COLOR;
    self.emptyConversationView = self.emptyLabel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:XJSetupUnreadMessagesCount object:nil];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Cell data source
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    for (RCConversationModel *model in dataSource) {
        if ([model.lastestMessage isKindOfClass:[XJPlanOrderMessage class]]) {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    return dataSource;
}

#pragma mark - rcConversation table view data source & delegate
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.f;
}
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    if ([model.lastestMessage isKindOfClass:[XJPlanOrderMessage class]]) {
        XJChatListCell *cell = [[XJChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatListCell"];
        cell.timeLabel.text = [RCKitUtility ConvertMessageTime:model.sentTime / 1000];
        cell.detailLabel.text = @"[方案订单消息]";
        if (model.unreadMessageCount > 0) {
            cell.unreadLabel.hidden = NO;
            cell.unreadLabel.text = [NSString stringWithFormat:@"%@", @(model.unreadMessageCount)];
        } else {
            cell.unreadLabel.hidden = YES;
        }
        if ([[XJDataBase sharedDataBase] selectUser:model.targetId].count > 0) {
            UserMessageModel *tempUserModel = [[XJDataBase sharedDataBase] selectUser:model.targetId][0];
            cell.nameLabel.text = tempUserModel.realname;
            [cell.avatarImageView sd_setImageWithURL:XLURLFromString(tempUserModel.headpictureurl) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
            model.conversationTitle = tempUserModel.realname;
        } else {
            [UserMessageModel fetchUserInfoByUserId:model.targetId handler:^(id object, NSString *msg) {
                if (object) {
                    UserMessageModel *userModel = object;
                    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                    userInfo.portraitUri = userModel.headpictureurl;
                    userInfo.name = userModel.realname;
                    [[XJDataBase sharedDataBase] insertUser:userModel];
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:model.targetId];
                    model.conversationTitle = userModel.realname;
                    GJCFAsyncMainQueue(^{
                        cell.nameLabel.text = userModel.realname;
                        [cell.avatarImageView sd_setImageWithURL:XLURLFromString(userModel.headpictureurl) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
                    });
                }
            }];
        }
        return cell;
    }
    return [XJChatListCell new];
}

#pragma mark - ConversationList delegate
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    XJChatViewController *chatController = [[XJChatViewController alloc] init];
    chatController.enableUnreadMessageIcon = YES;
    chatController.enableNewComingMessageIcon = YES;
    chatController.hidesBottomBarWhenPushed = YES;
    chatController.displayUserNameInCell = NO;
    chatController.conversationType = model.conversationType;
    chatController.targetId = model.targetId;
    chatController.title = model.conversationTitle;
    [self.navigationController pushViewController:chatController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getters
- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
        _emptyLabel.text = @"暂无消息";
        _emptyLabel.textColor = XJHexRGBColorWithAlpha(0x999999, 1);
        _emptyLabel.font = XJBoldSystemFont(16);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

@end
