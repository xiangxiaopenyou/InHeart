//
//  ExpertDetailViewController.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/22.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DoctorModel;

@interface ExpertDetailViewController : UIViewController
@property (strong, nonatomic) DoctorModel *doctorModel;
@property (assign, nonatomic) BOOL isChatting;

@end
