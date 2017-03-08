//
//  UserMessageModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserMessageModel.h"

#import "UsersNameAndIdRequest.h"

@implementation UserMessageModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userId" : @"id"};
}
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
@end
