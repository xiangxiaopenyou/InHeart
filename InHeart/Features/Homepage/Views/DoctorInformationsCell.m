//
//  DoctorInformationsCell.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "DoctorInformationsCell.h"

#import "DoctorModel.h"

#import <UIImage-Helpers.h>

@implementation DoctorInformationsCell
- (void)fillContents:(DoctorModel *)model {
}
+ (CGFloat)heightOfCell:(NSString *)specialityString {
    CGFloat height = 150.f;
    CGSize textSize = XLSizeOfText(specialityString, SCREEN_WIDTH - 30, XJSystemFont(14));
    return height + textSize.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.commonConsultButton setBackgroundImage:[UIImage imageWithColor:XJRGBColor(180, 180, 180, 1)] forState:UIControlStateHighlighted];
    [self.videoConsultButton setBackgroundImage:[UIImage imageWithColor:XJRGBColor(180, 180, 180, 1)] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
