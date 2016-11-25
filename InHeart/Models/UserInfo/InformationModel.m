//
//  InformationModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "InformationModel.h"
#import "EditInformationsRequest.h"

@implementation InformationModel
+ (void)editInformations:(InformationModel *)model handler:(RequestResultHandler)handler {
    [[EditInformationsRequest new] request:^BOOL(EditInformationsRequest *request) {
        request.model = model;
        return YES;
    } result:handler];
}

@end
