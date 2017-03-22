//
//  ChatViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChatViewController.h"
#import "ExpertDetailViewController.h"
#import "PrescriptionContentsViewController.h"

#import "XLBlockAlertView.h"
#import "PrescriptionMessageCell.h"

#import "ConversationModel.h"
#import "DoctorModel.h"
#import "UserMessageModel.h"

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
    PrescriptionContentsViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateViewControllerWithIdentifier:@"PrescriptionContents"];
    contentsViewController.prescriptionId = prescriptionId;
    [self.navigationController pushViewController:contentsViewController animated:YES];
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
        messageModel.avatarImage = [UIImage imageNamed:@"default_doctor_avatar"];
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
    [[[XLBlockAlertView alloc] initWithTitle:kCommonTip message:kIsMakePhoneCall block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *tempString = [NSString stringWithFormat:@"tel://%@", self.title];
            [[UIApplication sharedApplication] openURL:XLURLFromString(tempString) options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    } cancelButtonTitle:kCommonCancel otherButtonTitles:kCommonEnsure, nil] show];
}
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView {
    
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
                XLShowThenDismissHUD(NO, kNetworkError, self.view);
            }
        }];
    }

}

@end
