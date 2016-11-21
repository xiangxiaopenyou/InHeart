//
//  DoctorCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DoctorCell.h"
#import "DoctorModel.h"

#import <UIImageView+AFNetworking.h>

@implementation DoctorCell

- (void)setupContentWith:(DoctorModel *)model {
    [self.photoView setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.nameLabel.text = XLIsNullObject(model.realname) ? @"未知姓名" : [NSString stringWithFormat:@"%@", model.realname];
    self.levelLabel.text = XLIsNullObject(model.title) ? nil : [NSString stringWithFormat:@"%@", model.title];
    self.mottoLabel.text = XLIsNullObject(model.signature) ? nil : [NSString stringWithFormat:@"%@", model.signature];
    self.consultNumber.text = model.consultationTimes ?  [NSString stringWithFormat:@"%@人咨询过", model.consultationTimes] : @"0人咨询过";
    self.cityLabel.text = XLIsNullObject(model.region) ? @"未知地区" : [NSString stringWithFormat:@"%@", model.region];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
