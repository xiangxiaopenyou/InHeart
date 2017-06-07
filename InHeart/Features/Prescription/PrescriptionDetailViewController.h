//
//  PrescriptionDetailViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrescriptionModel;

typedef void (^paySuccessBlock)(PrescriptionModel *model);

@interface PrescriptionDetailViewController : UIViewController
@property (copy, nonatomic) NSString *prescriptionId;
@property (copy, nonatomic) paySuccessBlock block;


@end
