//
//  PrescriptionModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface PrescriptionModel : BaseModel
@property (copy, nonatomic) NSArray<Optional> *contents;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *creator;
@property (copy, nonatomic) NSString *doctorId;
@property (strong, nonatomic) NSNumber *hidden;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSDictionary<Optional> *patient;
@property (copy, nonatomic) NSString<Optional> *patientId;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString *suggestion;
@property (strong, nonatomic) NSNumber *total;
@property (copy, nonatomic) NSString<Optional> *updatedAt;
@property (copy, nonatomic) NSString<Optional> *updator;

+ (void)fetchPrescriptionContents:(NSString *)prescriptionId handler:(RequestResultHandler)handler;

@end
