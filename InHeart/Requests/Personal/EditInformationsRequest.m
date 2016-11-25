//
//  EditInformationsRequest.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EditInformationsRequest.h"
#import "InformationModel.h"

@implementation EditInformationsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (self.model.realname) {
        [self.params setObject:self.model.realname forKey:@"realname"];
    }
    if (self.model.idNumber) {
        [self.params setObject:self.model.idNumber forKey:@"idNumber"];
    }
    if (self.model.age) {
        [self.params setObject:self.model.age forKey:@"age"];
    }
    if (self.model.emergencyContact) {
        [self.params setObject:self.model.emergencyContact forKey:@"emergencyContact"];
    }
    if (self.model.emergencyContactPhone) {
        [self.params setObject:self.model.emergencyContactPhone forKey:@"emergencyContactPhone"];
    }
    if (self.model.address) {
        [self.params setObject:self.model.address forKey:@"address"];
    }
    [[RequestManager sharedInstance] POST:EDIT_INFORMATIONS parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, kNetworkError);
    }];
}

@end
