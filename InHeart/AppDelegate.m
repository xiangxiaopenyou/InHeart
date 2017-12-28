//
//  AppDelegate.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"

#import "UserInfo.h"

#import "WXApi.h"
#import "AppDelegate+RongCloud.h"
#import <UIImage-Helpers.h>
#import <OpenShareHeader.h>
#import <IQKeyboardManager.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //融云
    [self initRongCloudService:application option:launchOptions];
    //NSString *ryToken = [[NSUserDefaults standardUserDefaults] stringForKey:RYTOKEN];
    
    //注册微信
    [WXApi registerApp:WECHATAPPID];
    
    //OpenShare
    [OpenShare connectWeixinWithAppId:WECHATAPPID];
    [OpenShare setPaySuccessCallback:^(NSDictionary *message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XJDidReceiveWechatPayResponse object:message];
    }];
    [OpenShare setPayFailCallback:^(NSDictionary *message, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XJDidReceiveWechatPayResponse object:message];
    }];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    [self initAppearance];
    [self checkUserState:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserState:) name:XJLoginSuccess object:nil];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
//注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
//接收到远程推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)initAppearance {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : TABBAR_TITLE_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : NAVIGATIONBAR_COLOR} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                 NSFontAttributeName : XJBoldSystemFont(18)}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}
//登录状态变化
- (void)checkUserState:(NSNotification *)notification {
    if ([[UserInfo sharedUserInfo] isLogined]) {
        MainTabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBar"];
        self.window.rootViewController = tabBarController;
        NSString *tokenString = [[NSUserDefaults standardUserDefaults] stringForKey:RYTOKEN];
        [[RCIM sharedRCIM] connectWithToken:tokenString success:^(NSString *userId) {
        } error:^(RCConnectErrorCode status) {
        } tokenIncorrect:^{
        }];
    } else {
        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        self.window.rootViewController = navigationController;
    }
    [self.window makeKeyAndVisible];
}

- (void)onReq:(BaseReq *)req {
    
}
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
//    NSString *payResoult = [NSString stringWithFormat:@"%@", @(resp.errCode)];
    if([resp isKindOfClass:[PayResp class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:XJDidReceiveWechatPayResponse object:resp];
    }
}

@end
