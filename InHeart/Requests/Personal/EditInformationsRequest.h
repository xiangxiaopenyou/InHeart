//
//  EditInformationsRequest.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"
@class InformationModel;

@interface EditInformationsRequest : BaseRequest
@property (strong, nonatomic) InformationModel *model;

@end
