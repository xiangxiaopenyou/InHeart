//
//  PersonalInformationCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalInformationCell.h"
@interface PersonalInformationCell()
@end

@implementation PersonalInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    //上分割线
//    CGContextSetStrokeColorWithColor(context, kHexRGBColorWithAlpha(0xb0b0b0, 1.0).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, kHexRGBColorWithAlpha(0xb0b0b0, 1.0).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
//}

@end
