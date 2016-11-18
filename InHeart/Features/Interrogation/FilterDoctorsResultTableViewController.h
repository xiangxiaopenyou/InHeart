//
//  FilterDoctorsResultTableViewController.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterDoctorsResultTableViewController : UITableViewController
@property (assign, nonatomic) NSInteger filterType;
@property (copy, nonatomic) NSString *cityCode;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *diseaseString;

@end
