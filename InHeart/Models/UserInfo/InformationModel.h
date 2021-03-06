//
//  InformationModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface InformationModel : XLModel
@property (copy, nonatomic) NSString *idNumber;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *age;
@property (copy, nonatomic) NSString *emergencyContact;
@property (copy, nonatomic) NSString *emergencyContactPhone;

+ (void)editInformations:(InformationModel *)model handler:(RequestResultHandler)handler;

@end
