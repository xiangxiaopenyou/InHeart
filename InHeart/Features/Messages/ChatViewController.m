//
//  ChatViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChatViewController.h"
#import "ExpertDetailViewController.h"
#import "PrescriptionDetailViewController.h"

#import "XLBlockAlertView.h"
#import "PrescriptionMessageCell.h"

#import "ConversationModel.h"
#import "DoctorModel.h"
#import "UserMessageModel.h"
#import "PrescriptionModel.h"
#import "ContentModel.h"

#import "DemoCallManager.h"

@interface ChatViewController ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_person"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.title = XLIsNullObject(self.conversationModel.realname) ? self.conversationModel.conversation.conversationId : self.conversationModel.realname;
    [[EaseBaseMessageCell appearance] setMessageNameIsHidden:YES];
    //[EaseBaseMessageCell appearance].hasRead.hidden = YES;
    self.delegate = self;
    self.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)pushToDoctorDetailView {
    ExpertDetailViewController *expertDetailController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertDetail"];
    DoctorModel *tempModel = [DoctorModel new];
    tempModel.id = self.conversationModel.userId;
    expertDetailController.doctorModel = tempModel;
    expertDetailController.isChatting = YES;
    [self.navigationController pushViewController:expertDetailController animated:YES];
}
- (void)pushToPrescriptionContentsView:(NSString *)prescriptionId {
    GJCFAsyncMainQueue(^{
        PrescriptionDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Prescription" bundle:nil] instantiateViewControllerWithIdentifier:@"PrescriptionDetail"];
        detailViewController.prescriptionId = prescriptionId;
        detailViewController.block = ^(PrescriptionModel *model) {
            if (model) {
                [self createPaySuccessMessage:model];
            }
        };
        [self.navigationController pushViewController:detailViewController animated:YES];
    });
}
//创建支付处方成功消息
- (void)createPaySuccessMessage:(PrescriptionModel *)model {
    NSArray *array = [model.prescriptionContentList copy];
    ContentModel *tempModel = [ContentModel yy_modelWithDictionary:array[0]];
    NSDictionary *param = @{        @"imageUrl" : tempModel.coverPic,
                              @"prescriptionId" : model.id,
                                       @"price" : model.price,
                                      @"status" : @(2)};
    EMMessage *prescriptionMessage = [EaseSDKHelper sendTextMessage:@"[处方支付]" to:self.conversation.conversationId messageType:EMChatTypeChat messageExt:param];
    [self addMessageToDataSource:prescriptionMessage progress:nil];
    [self.conversation insertMessage:prescriptionMessage error:nil];
    [[EMClient sharedClient].chatManager sendMessage:prescriptionMessage progress:nil completion:nil];
}

#pragma mark - EaseMessageViewController Delegate & DataSource
- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageModel *tempModel = object;
        if (!tempModel.message.ext[@"prescriptionId"]) {
            EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel {
    if (messageModel.isSender) {
        messageModel.avatarImage = [UIImage imageNamed:@"personal_avatar"];
    } else {
        if (XLIsNullObject(self.conversationModel.avatarUrl)) {
            messageModel.avatarImage = [UIImage imageNamed:@"default_doctor_avatar"];
        } else {
            messageModel.avatarURLPath = self.conversationModel.avatarUrl;
        }
    }
    if (messageModel.message.ext[@"prescriptionId"]) {
        PrescriptionMessageCell *cell = [[PrescriptionMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContents:messageModel];
        cell.selectBlock = ^(){
            NSString *prescriptionId = messageModel.message.ext[@"prescriptionId"];
            [self pushToPrescriptionContentsView:prescriptionId];
        };
        cell.avatarBlock = ^(){
            if (!messageModel.isSender) {
                [self rightButtonAction];
            }
        };
        return cell;
    }
    return nil;
}
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    if (messageModel.message.ext[@"prescriptionId"]) {
        return 120;
    } else {
        return [EaseMessageCell cellHeightWithModel:messageModel];
    }
}
- (void)messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    if (!messageModel.isSender) {
        [self rightButtonAction];
    }
}


#pragma mark - EaseChatBarMoreViewDelegate
- (void)moreViewPhoneCallAction:(EaseChatBarMoreView *)moreView {
    [self.chatToolbar endEditing:YES];
    NSString *tempString = [NSString stringWithFormat:@"tel://%@", self.title];
    [[UIApplication sharedApplication] openURL:XLURLFromString(tempString) options:@{} completionHandler:^(BOOL success) {
        
    }];
}
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView {
    [self.chatToolbar endEditing:YES];
    [[DemoCallManager sharedManager] makeCallWithUsername:self.conversationModel.conversation.conversationId type:EMCallTypeVideo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)rightButtonAction {
    if (!XLIsNullObject(self.conversationModel.userId)) {
        [self pushToDoctorDetailView];
    } else {
        [UserMessageModel fetchUsersIdAndName:self.conversationModel.conversation.conversationId handler:^(id object, NSString *msg) {
            if (object) {
                UserMessageModel *userModel = object;
                self.conversationModel.userId = userModel.userId;
                self.conversationModel.realname = userModel.realname;
                [self pushToDoctorDetailView];
            } else {
                XLShowThenDismissHUD(NO, XJNetworkError, self.view);
            }
        }];
    }

}

@end
