//
//  UserInfo.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface UserInfo : NSObject <RCIMUserInfoDataSource, RCIMReceiveMessageDelegate>

+ (UserInfo *)sharedUserInfo;
- (BOOL)isLogined;
- (BOOL)saveUserInfo:(UserModel *)userModel;
- (UserModel *)userInfo;
- (void)removeUserInfo;
- (BOOL)shouldLogin:(UIViewController *)viewController;

@end
