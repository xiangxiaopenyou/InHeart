//
//  DoctorModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DoctorModel.h"
#import "ProvinceModel.h"

#import "FetchDoctorsListRequest.h"
#import "FetchDiseasesRequest.h"
#import "FetchAreasRequest.h"
#import "FetchDoctorsDetailRequest.h"
#import "AddAttentionRequest.h"
#import "CancelAttentionRequest.h"
#import "FetchConcernedDoctorsRequest.h"

@implementation DoctorModel
+ (void)fetchDoctorsList:(NSString *)keyword region:(NSString *)region disease:(NSString *)disease paging:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[FetchDoctorsListRequest new] request:^BOOL(FetchDoctorsListRequest *request) {
        request.keyword = keyword;
        request.region = region;
        request.disease = disease;
        request.paging =paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [[DoctorModel class] setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchDiseasesList:(RequestResultHandler)handler {
    [[FetchDiseasesRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)fetchAreasList:(RequestResultHandler)handler {
    [[FetchAreasRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [[ProvinceModel class] setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchDoctorDetail:(NSString *)doctorId handler:(RequestResultHandler)handler {
    [[FetchDoctorsDetailRequest new] request:^BOOL(FetchDoctorsDetailRequest *request) {
        request.doctorId = doctorId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            DoctorModel *tempModel = [[DoctorModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)addAttention:(NSString *)doctorId handler:(RequestResultHandler)handler {
    [[AddAttentionRequest new] request:^BOOL(AddAttentionRequest *request) {
        request.doctorId = doctorId;
        return YES;
    } result:handler];
}
+ (void)cancelAttention:(NSString *)doctorId handler:(RequestResultHandler)handler {
    [[CancelAttentionRequest new] request:^BOOL(CancelAttentionRequest *request) {
        request.doctorId = doctorId;
        return YES;
    } result:handler];
}
+ (void)fetchConcernedDoctors:(RequestResultHandler)handler {
    [[FetchConcernedDoctorsRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [object copy];
            NSArray *resultArray = [[DoctorModel class] setupWithArray:tempArray];
            !handler ?: handler(resultArray, nil);
        }
    }];
}

@end
