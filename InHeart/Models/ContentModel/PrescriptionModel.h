//
//  PrescriptionModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface PrescriptionModel : XLModel
@property (copy, nonatomic) NSArray *contents;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *creator;
@property (copy, nonatomic) NSString *doctorId;
@property (strong, nonatomic) NSNumber *hidden;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSDictionary *patient;
@property (copy, nonatomic) NSString *patientId;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString *suggestion;
@property (strong, nonatomic) NSNumber *total;
@property (copy, nonatomic) NSString *updatedAt;
@property (copy, nonatomic) NSString *updator;

+ (void)fetchPrescriptionContents:(NSString *)prescriptionId handler:(RequestResultHandler)handler;

@end
