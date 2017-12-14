//
//  MainTabBarController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomepageNavigationController.h"
#import "HomepageViewController.h"
#import "NewsViewController.h"
#import "PersonalNavigationController.h"
#import "PersonalCenterViewController.h"
#import "XJConversationListViewController.h"

#import "UserInfo.h"
#import "UserModel.h"

static CGFloat const kTipLabelHeight = 2.0;
#define kTipLabelWidth SCREEN_WIDTH / 4.0
//#define kTipLabelWidth SCREEN_WIDTH / 3.0


@interface MainTabBarController ()
@property (strong, nonatomic) UILabel *bottomTipLabel;

@end

@implementation MainTabBarController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewToTabBar];
    UIImage *homepageUnselectedImage = [UIImage imageNamed:@"homepage_unselected"];
    homepageUnselectedImage = [homepageUnselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *homepageSelectedImage = [UIImage imageNamed:@"homepage_selected"];
    homepageSelectedImage = [homepageSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *newsUnselectedImage = [UIImage imageNamed:@"news_unselected"];
    newsUnselectedImage = [newsUnselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    ;
    UIImage *newsSelectedImage = [UIImage imageNamed:@"news_selected"];
    newsSelectedImage = [newsSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *messageUnSelectedImage = [UIImage imageNamed:@"message_unselected"];
    messageUnSelectedImage = [messageUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *messageSelectedImage = [UIImage imageNamed:@"message_selected"];
    messageSelectedImage = [messageSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *personalUnSelectedImage = [UIImage imageNamed:@"personal_unselected"];
    personalUnSelectedImage = [personalUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *personalSelectedImage = [UIImage imageNamed:@"personal_selected"];
    personalSelectedImage = [personalSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //首页
    HomepageViewController *homepageController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HomepageView"];
    [self setupChildControllerWith:homepageController normalImage:homepageUnselectedImage selectedImage:homepageSelectedImage title:@"首页" index:0];
    
    //心景头条
    NewsViewController *newsController= [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateViewControllerWithIdentifier:@"News"];
    [self setupChildControllerWith:newsController normalImage:newsUnselectedImage selectedImage:newsSelectedImage title:@"心景头条" index:1];
    
    //消息
    XJConversationListViewController *messageController = [[XJConversationListViewController alloc] init];
    [self setupChildControllerWith:messageController normalImage:messageUnSelectedImage selectedImage:messageSelectedImage title:@"消息" index:2];
    
    //个人中心
    //PersonalCenterTableViewController *personalViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCenterViewController *personalViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenterView"];
    [self setupChildControllerWith:personalViewController normalImage:personalUnSelectedImage selectedImage:personalSelectedImage title:@"个人中心" index:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessagesCount) name:XJSetupUnreadMessagesCount object:nil];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self setupUnreadMessagesCount];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)addViewToTabBar {
    [self.tabBar addSubview:self.bottomTipLabel];
}

- (void)setupChildControllerWith:(UIViewController *)childViewController normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title index:(NSInteger)index {
    if (index == 0) {
        HomepageNavigationController *navigationController = [[HomepageNavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigationController];
    } else if (index == 3) {
        PersonalNavigationController *navigation = [[PersonalNavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigation];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigationController];
    }
    
 
}
- (void)changeTipLabelPosition:(CGFloat)positionX {
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomTipLabel.frame = CGRectMake(positionX, 0, kTipLabelWidth, kTipLabelHeight);
    }];
}
//- (void)showNotificationWithMessage:(EMMessage *)message {
//    //本地推送
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate date]; //触发通知的时间
////    notification.alertBody = NSEaseLocalizedString(@"receiveMessage", @"you have a new message");
//    //发送通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//}
//设置未读消息数量
//- (void)setupUnreadMessagesCount {
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    NSInteger unreadCount = 0;
//    for (EMConversation *conversation in conversations) {
//        unreadCount += conversation.unreadMessagesCount;
//    }
//    UITabBarItem *item = self.tabBar.items[2];
//    item.badgeValue = unreadCount > 0 ? [NSString stringWithFormat:@"%@", @(unreadCount)] : nil;
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
//}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    CGFloat positionX = index * kTipLabelWidth;
    [self changeTipLabelPosition:positionX];
}
#pragma mark - EMChatManagerDelegate
- (void)messagesDidReceive:(NSArray *)aMessages {
//    for (EMMessage *message in aMessages) {
//        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//        switch (state) {
//            case UIApplicationStateBackground:{
//                [self showNotificationWithMessage:message];
//            }
//                break;
//
//            default:
//                break;
//        }
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:XJConversationsDidChange object:nil];
//    [self setupUnreadMessagesCount];
}
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [[NSNotificationCenter defaultCenter] postNotificationName:XJConversationsDidChange object:nil];
//    [self setupUnreadMessagesCount];
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
- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTipLabelWidth, kTipLabelHeight)];
        _bottomTipLabel.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return _bottomTipLabel;
}

@end
