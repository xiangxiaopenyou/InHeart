//
//  ContentTypeModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentTypeModel.h"

@implementation ContentTypeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"typeId" : @"id"};
}

@end
