//
//  UserMessageModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface UserMessageModel : XLModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *headpictureurl;
@property (copy, nonatomic) NSString *phone;

+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler;

@end
