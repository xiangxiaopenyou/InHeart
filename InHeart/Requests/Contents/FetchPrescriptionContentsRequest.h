//
//  FetchPrescriptionContentsRequest.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchPrescriptionContentsRequest : BaseRequest
@property (copy, nonatomic) NSString *prescriptionId;

@end
