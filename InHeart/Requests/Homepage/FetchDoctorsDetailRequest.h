//
//  FetchDoctorsDetailRequest.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchDoctorsDetailRequest : BaseRequest
@property (copy, nonatomic) NSString *doctorId;

@end