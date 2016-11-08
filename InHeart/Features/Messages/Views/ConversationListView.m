//
//  ConversationListView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ConversationListView.h"
#import <GJCFUitils.h>
#import <EMConversation.h>
//#import <EMSDK.h>
@interface ConversationListView ()<UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *conversationArray;

@end

@implementation ConversationListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARHEIGHT);
        [self removeEmptyConversationsFromDB];
        [self fetchConversations];
    }
    return self;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = BREAK_LINE_COLOR;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)fetchConversations {
    NSArray *tempArray = [[[EMClient sharedClient].chatManager getAllConversations] copy];
    self.conversationArray = [[NSMutableArray alloc] init];
    for (EMConversation *conversation in tempArray) {
        EaseConversationModel *tempModel = [[EaseConversationModel alloc] initWithConversation:conversation];
        [self.conversationArray addObject:tempModel];
    }
    [self.tableView reloadData];
}

- (void)removeEmptyConversationsFromDB {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EaseConversationCell *cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.avatarView.imageCornerRadius = CGRectGetWidth(cell.avatarView.frame) / 2.0;
    cell.avatarView.imageView.backgroundColor = [UIColor clearColor];
    cell.titleLabelFont = kSystemFont(15);
    cell.titleLabelColor = MAIN_TEXT_COLOR;
    cell.detailLabelFont = kSystemFont(14);
    cell.detailLabelColor = TABBAR_TITLE_COLOR;
    cell.timeLabelFont = kSystemFont(13);
    cell.timeLabelColor = TABBAR_TITLE_COLOR;
    EaseConversationModel *tempModel = self.conversationArray[indexPath.row];
    EMMessage *lastMessage = tempModel.conversation.latestMessage;
    cell.titleLabel.text = tempModel.conversation.conversationId;
    [cell.avatarView.imageView setImage:[UIImage imageNamed:@"default_doctor_avatar"]];
    cell.detailLabel.text = [self messageTextForLastMessage:tempModel];
    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:lastMessage.timestamp];
    cell.timeLabel.text = XLDetailTimeAgoString(messageDate);
    NSInteger unreadMessagesNumber = tempModel.conversation.unreadMessagesCount;
    if (unreadMessagesNumber > 0) {
        cell.avatarView.badge = unreadMessagesNumber;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EaseConversationModel *tempModel = self.conversationArray[indexPath.row];
    if (self.block) {
        self.block(tempModel);
    }
}
- (NSString *)messageTextForLastMessage:(EaseConversationModel *)model {
    NSString *text = @"";
    EMMessage *lastMessage = model.conversation.latestMessage;
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:{
                NSString *tempString = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                text = tempString;
            }
                break;
            case EMMessageBodyTypeVoice:{
                text = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            }
                break;
            case EMMessageBodyTypeImage:{
                text = NSEaseLocalizedString(@"message.image1", @"[image]");
            }
                break;
                
            default:
                break;
        }
    }
    return text;
}

#pragma mark - EMChatManagerDelegate
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [self fetchConversations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
