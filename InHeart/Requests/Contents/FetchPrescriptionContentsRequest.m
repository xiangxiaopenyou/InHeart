//
//  FetchPrescriptionContentsRequest.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchPrescriptionContentsRequest.h"

@implementation FetchPrescriptionContentsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.prescriptionId forKey:@"prescriptionId"];
    [[RequestManager sharedInstance] POST:FETCH_PRESCRIPTION_CONTENTS parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
