//
//  MessagesViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MessagesViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "ConversationListView.h"

#import "UserModel.h"
#import "UserInfo.h"
#import "ConversationModel.h"

@interface MessagesViewController ()<ConversationListViewDelegate>
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
    self.conversationsView.block = ^(ConversationModel *model){
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:EMConversationTypeChat];
            //chatViewController.title = model.conversation.conversationId;
            chatViewController.hidesBottomBarWhenPushed = YES;
            chatViewController.conversationModel = model;
            [strongSelf.navigationController pushViewController:chatViewController animated:YES];
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationsDidChange) name:XJConversationsDidChange object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[UserInfo sharedUserInfo] isLogined]) {
        if (![[EMClient sharedClient] isLoggedIn]) {
            UserModel *person = [[UserInfo sharedUserInfo] userInfo];
            [[EMClient sharedClient] loginWithUsername:person.username password:person.encryptPw completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    [self.conversationsView fetchConversations];
                } else {
                    XLShowThenDismissHUD(NO, XJNetworkError, self.view);
                }
            }];
        } else {
            [self.conversationsView fetchConversations];
        }
    } else {
        [self.conversationsView.tableView reloadData];
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
        _conversationsView.delegate = self;
    }
    return _conversationsView;
}

#pragma mark - ConversationListViewDelegate
- (void)didClickLogin {
    LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)conversationsDidChange {
    [self.conversationsView fetchConversations];
}

@end
