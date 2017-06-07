//
//  DoctorInformationsCell.h
//  InHeart
//
//  Created by 项小盆友 on 2017/6/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DoctorModel;

@interface DoctorInformationsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;
@property (weak, nonatomic) IBOutlet UIButton *commonConsultButton;
@property (weak, nonatomic) IBOutlet UILabel *commonConsultFeesLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoConsultButton;
@property (weak, nonatomic) IBOutlet UILabel *videoConsultFeesLabel;

- (void)fillContents:(DoctorModel *)model;
+ (CGFloat)heightOfCell:(NSString *)specialityString;

@end
