//
//  FetchDoctorsListRequest.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchDoctorsListRequest : BaseRequest
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *disease;
@property (strong, nonatomic) NSNumber *paging;


@end
