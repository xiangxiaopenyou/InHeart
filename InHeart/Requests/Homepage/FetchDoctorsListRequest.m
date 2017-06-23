//
//  FetchDoctorsListRequest.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchDoctorsListRequest.h"

@implementation FetchDoctorsListRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (!XLIsNullObject(self.keyword)) {
        [self.params setObject:self.keyword forKey:@"keyword"];
    }
    if (!XLIsNullObject(self.region)) {
        [self.params setObject:self.region forKey:@"region"];
    }
    if (!XLIsNullObject(self.disease)) {
        [self.params setObject:self.disease forKey:@"disease"];
    }
    [self.params setObject:self.paging forKey:@"paging"];
    [[RequestManager sharedInstance] POST:FETCH_DOCTORS_LIST parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
