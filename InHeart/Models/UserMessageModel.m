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
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId" : @"id"}];
}
+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler {
    [[UsersNameAndIdRequest new] request:^BOOL(UsersNameAndIdRequest *request) {
        request.username = phone;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserMessageModel *tempModel = [[UserMessageModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
@end
