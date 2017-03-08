//
//  PrescriptionModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PrescriptionModel.h"
#import "FetchPrescriptionContentsRequest.h"

@implementation PrescriptionModel
+ (void)fetchPrescriptionContents:(NSString *)prescriptionId handler:(RequestResultHandler)handler {
    [[FetchPrescriptionContentsRequest new] request:^BOOL(FetchPrescriptionContentsRequest *request) {
        request.prescriptionId = prescriptionId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            PrescriptionModel *tempModel = [PrescriptionModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}

@end
