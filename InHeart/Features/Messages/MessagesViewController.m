//
//  MessagesViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MessagesViewController.h"
#import "ChatViewController.h"
#import "ConversationListView.h"

#import "PersonalInfo.h"
#import "UserInfo.h"

#import <Masonry.h>
#import <GJCFUitils.h>

@interface MessagesViewController ()
@property (strong, nonatomic) ConversationListView *conversationsView;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.conversationsView];
    [self.conversationsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
    GJCFWeakSelf weakSelf = self;
    self.conversationsView.block = ^(EaseConversationModel *model){
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:EMConversationTypeChat];
            chatViewController.hidesBottomBarWhenPushed = YES;
            chatViewController.title = model.conversation.conversationId;
            [strongSelf.navigationController pushViewController:chatViewController animated:YES];
        }
    };
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"聊天" style:UIBarButtonItemStylePlain target:self action:@selector(chatAction)];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[UserInfo sharedUserInfo] isLogined]) {
        if (![[EMClient sharedClient] isLoggedIn]) {
            PersonalInfo *person = [[UserInfo sharedUserInfo] personalInfo];
            [[EMClient sharedClient] loginWithUsername:person.username password:person.password completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    [self.conversationsView fetchConversations];
                } else {
                    [SVProgressHUD showErrorWithStatus:kNetworkError];
                }
            }];
        } else {
            [self.conversationsView fetchConversations];
        }
    } else {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (ConversationListView *)conversationsView {
    if (!_conversationsView) {
        _conversationsView = [[ConversationListView alloc] init];
    }
    return _conversationsView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)chatAction {
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:@"13732254511" conversationType:EMConversationTypeChat];
    chatViewController.hidesBottomBarWhenPushed = YES;
    chatViewController.title = @"13732254511";
    [self.navigationController pushViewController:chatViewController animated:YES];
}

@end
