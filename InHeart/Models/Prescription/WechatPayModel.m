//
//  WechatPayModel.m
//  InHeart
//
//  Created by 项小盆友 on 2017/5/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "WechatPayModel.h"
#import "WechatPayRequest.h"

@implementation WechatPayModel
+ (void)wechatPay:(NSString *)prescriptionId handler:(RequestResultHandler)handler {
    [[WechatPayRequest new] request:^BOOL(WechatPayRequest *request) {
        request.prescriptionId = prescriptionId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            WechatPayModel *tempModel = [WechatPayModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}

@end
