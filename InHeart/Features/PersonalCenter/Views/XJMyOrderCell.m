//
//  XJMyOrderCell.m
//  InHeart
//
//  Created by 项小盆友 on 2017/7/4.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJMyOrderCell.h"
@interface XJMyOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfContent;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation XJMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
