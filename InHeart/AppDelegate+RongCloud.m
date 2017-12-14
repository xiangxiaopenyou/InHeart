//
//  AppDelegate+RongCloud.m
//  InHeart
//
//  Created by 项小盆友 on 2017/12/4.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AppDelegate+RongCloud.h"
#import "UserInfo.h"
#import "XJPlanOrderMessage.h"

static NSString *const kXJRongCloudAppKey = @"0vnjpoad0g5rz";

@implementation AppDelegate (RongCloud)
- (void)initRongCloudService:(UIApplication *)application option:(NSDictionary *)launchOptions {
    [[RCIMClient sharedRCIMClient] initWithAppKey:kXJRongCloudAppKey];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].userInfoDataSource = [UserInfo sharedUserInfo];
    [[RCIM sharedRCIM] registerMessageType:[XJPlanOrderMessage class]];
}
@end
