//
//  UserInfo.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserInfo.h"
#import "UserModel.h"
#import "UserMessageModel.h"
#import "XJDataBase.h"

#import "LoginViewController.h"

@implementation UserInfo
+ (UserInfo *)sharedUserInfo {
    static UserInfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfo alloc] init];
    });
    return instance;
}
- (BOOL)isLogined {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)saveUserInfo:(UserModel *)userModel {
    if (!userModel) {
        return NO;
    }
    if (userModel.token) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:USERTOKEN];
    }
    if (userModel.username) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.username forKey:USERNAME];
    }
    if (userModel.realname) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.realname forKey:USERREALNAME];
    }
    if (userModel.rytoken) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.rytoken forKey:RYTOKEN];
    }
    if (userModel.userId) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.userId forKey:USERID];
    }
    if (userModel.headPictureUrl) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.headPictureUrl forKey:USERAVATARSTRING];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
- (UserModel *)userInfo {
    UserModel *model = [UserModel new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERTOKEN]) {
        model.token = [[NSUserDefaults standardUserDefaults] objectForKey:USERTOKEN];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERNAME]) {
        model.username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERREALNAME]) {
        model.realname = [[NSUserDefaults standardUserDefaults] objectForKey:USERREALNAME];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RYTOKEN]) {
        model.rytoken = [[NSUserDefaults standardUserDefaults] objectForKey:RYTOKEN];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID]) {
        model.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERAVATARSTRING]) {
        model.headPictureUrl = [[NSUserDefaults standardUserDefaults] objectForKey:USERAVATARSTRING];
    }
    return model;
}
- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERREALNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RYTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERAVATARSTRING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)shouldLogin:(UIViewController *)viewController {
    if (![self isLogined]) {
        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [viewController presentViewController:navigationController animated:YES completion:nil];
        return YES;
    }
    return NO;
}

#pragma mark - RCIMUserInfo data source
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    if (userId.length == 0) {
        userInfo.userId = userId;
        userInfo.portraitUri = nil;
        userInfo.name = nil;
        completion(userInfo);
        return;
    }
    NSString *currentUserId = [RCIM sharedRCIM].currentUserInfo.userId;
    userInfo.userId = userId;
    if ([userId isEqualToString:currentUserId]) {
        userInfo.portraitUri = [[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING];
        userInfo.name = [[NSUserDefaults standardUserDefaults] stringForKey:USERREALNAME];
        completion(userInfo);
    } else {
        NSArray *tempArray = [[[XJDataBase sharedDataBase] selectUser:userId] copy];
        if ([[XJDataBase sharedDataBase] selectUser:userId].count > 0) {
            UserMessageModel *model = tempArray[0];
            userInfo.portraitUri = model.headpictureurl;
            userInfo.name = model.realname;
            completion(userInfo);
        } else {
            [UserMessageModel fetchUserInfoByUserId:userId handler:^(id object, NSString *msg) {
                if (object) {
                    UserMessageModel *userModel = object;
                    userInfo.portraitUri = userModel.headpictureurl;
                    userInfo.name = userModel.realname;
                    [[XJDataBase sharedDataBase] insertUser:userModel];
                    completion(userInfo);
                }
            }];
        }
        
    }
    
}


@end
