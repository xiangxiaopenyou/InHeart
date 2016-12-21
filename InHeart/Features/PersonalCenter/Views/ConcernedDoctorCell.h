//
//  ConcernedDoctorCell.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConcernedDoctorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstraint;

@end
