//
//  ContentTypeModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface ContentTypeModel : XLModel
@property (copy, nonatomic) NSString *typeId;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *status;

@end
