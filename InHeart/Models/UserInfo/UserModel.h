//
//  UserModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface UserModel : XLModel
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *username;
@property (strong, nonatomic) NSNumber *code;
@property (copy, nonatomic) NSString *encryptPw;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *headPictureUrl;

+ (void)userLogin:(NSString *)username password:(NSString *)password handler:(RequestResultHandler)handler;
+ (void)fetchCode:(NSString *)phoneNumber handler:(RequestResultHandler)handler;
+ (void)userRegister:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler;
+ (void)findPassword:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler;
+ (void)userLogout:(RequestResultHandler)handler;
@end
