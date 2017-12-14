//
//  UserMessageModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserMessageModel.h"

#import "UsersNameAndIdRequest.h"
#import "XJFetchUserInfoRequest.h"

@implementation UserMessageModel
+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler {
    [[UsersNameAndIdRequest new] request:^BOOL(UsersNameAndIdRequest *request) {
        request.username = phone;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserMessageModel *tempModel = [UserMessageModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchUserInfoByUserId:(NSString *)userId handler:(RequestResultHandler)handler {
    [[XJFetchUserInfoRequest new] request:^BOOL(XJFetchUserInfoRequest *request) {
        request.userId = userId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserMessageModel *tempModel = [UserMessageModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
@end
