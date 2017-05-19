//
//  WechatPayModel.h
//  InHeart
//
//  Created by 项小盆友 on 2017/5/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface WechatPayModel : XLModel
@property (copy, nonatomic) NSString *appId;
@property (copy, nonatomic) NSString *noncestr;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *out_trade_no;
@property (copy, nonatomic) NSString *package;
@property (copy, nonatomic) NSString *partnerid;
@property (copy, nonatomic) NSString *prepayid;
@property (copy, nonatomic) NSString *sign;
@property (copy, nonatomic) NSString *timestamp;

+ (void)wechatPay:(NSString *)prescriptionId handler:(RequestResultHandler)handler;

@end
