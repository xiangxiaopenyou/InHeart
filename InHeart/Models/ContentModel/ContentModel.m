//
//  ContentModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentModel.h"
#import "FetchContentDetailRequest.h"

@implementation ContentModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"contentId" : @"id"};
}
+ (void)fetchContentDetail:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[FetchContentDetailRequest new] request:^BOOL(FetchContentDetailRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            ContentModel *tempModel = [ContentModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
@end

