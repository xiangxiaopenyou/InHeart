//
//  UserInfo.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserInfo.h"
#import "UserModel.h"

#import "PersonalInfo.h"
#import <SAMKeychain.h>

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
    return model;
}
- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)savePersonalInfo:(PersonalInfo *)personalInfo {
    if (!personalInfo) {
        return NO;
    }
    [SAMKeychain setPassword:personalInfo.password forService:KEYCHAINSERVICE account:personalInfo.username error:nil];
    return YES;
}
- (PersonalInfo *)personalInfo {
    PersonalInfo *info = [PersonalInfo new];
    UserModel *tempModel = [self userInfo];
    NSString *username = tempModel.username;
    NSString *password = [SAMKeychain passwordForService:KEYCHAINSERVICE account:username];
    info.username = username;
    info.password = password;
    return info;
}
- (void)removePersonalInfo {
    UserModel *tempModel = [self userInfo];
    NSString *username = tempModel.username;
    [SAMKeychain deletePasswordForService:KEYCHAINSERVICE account:username error:nil];
}

@end
