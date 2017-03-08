//
//  DoctorModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface DoctorModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber *age;
@property (copy, nonatomic) NSString *certificate;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *entryDate;
@property (copy, nonatomic) NSString *expertise;
@property (copy, nonatomic) NSString *headPictureUrl;
@property (copy, nonatomic) NSString *hospital;
@property (copy, nonatomic) NSString *idCardFront;
@property (copy, nonatomic) NSString *idCardInverse;
@property (copy, nonatomic) NSString *idNumber;
@property (copy, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSNumber *isVisitPatient;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *photo;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *signature;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *consultationTimes;
@property (strong, nonatomic) NSNumber *isCollect;
@property (strong, nonatomic) NSNumber *minPrice;

+ (void)fetchDoctorsList:(NSString *)keyword region:(NSString *)region disease:(NSString *)disease paging:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)fetchDiseasesList:(RequestResultHandler)handler;
+ (void)fetchAreasList:(RequestResultHandler)handler;
+ (void)fetchDoctorDetail:(NSString *)doctorId handler:(RequestResultHandler)handler;
+ (void)addAttention:(NSString *)doctorId handler:(RequestResultHandler)handler;
+ (void)cancelAttention:(NSString *)doctorId handler:(RequestResultHandler)handler;
+ (void)fetchConcernedDoctors:(RequestResultHandler)handler;


@end
