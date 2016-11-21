//
//  DoctorModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface DoctorModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber<Optional> *age;
@property (copy, nonatomic) NSString<Optional> *certificate;
@property (copy, nonatomic) NSString<Optional> *email;
@property (copy, nonatomic) NSString<Optional> *entryDate;
@property (copy, nonatomic) NSString<Optional> *expertise;
@property (copy, nonatomic) NSString<Optional> *headPictureUrl;
@property (copy, nonatomic) NSString<Optional> *hospital;
@property (copy, nonatomic) NSString<Optional> *idCardFront;
@property (copy, nonatomic) NSString<Optional> *idCardInverse;
@property (copy, nonatomic) NSString<Optional> *idNumber;
@property (copy, nonatomic) NSString<Optional> *introduction;
@property (strong, nonatomic) NSNumber<Optional> *isVisitPatient;
@property (copy, nonatomic) NSString<Optional> *mobile;
@property (copy, nonatomic) NSString<Optional> *photo;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString<Optional> *region;
@property (copy, nonatomic) NSString<Optional> *signature;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString<Optional> *token;
@property (copy, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSNumber<Optional> *consultationTimes;
@property (strong, nonatomic) NSNumber<Optional> *isCollect;
@property (strong, nonatomic) NSNumber<Optional> *minPrice;

+ (void)fetchDoctorsList:(NSString *)keyword region:(NSString *)region disease:(NSString *)disease paging:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)fetchDiseasesList:(RequestResultHandler)handler;
+ (void)fetchAreasList:(RequestResultHandler)handler;
+ (void)fetchDoctorDetail:(NSString *)doctorId handler:(RequestResultHandler)handler;
+ (void)addAttention:(NSString *)doctorId handler:(RequestResultHandler)handler;
+ (void)cancelAttention:(NSString *)doctorId handler:(RequestResultHandler)handler;


@end
