//
//  NewsTopCell.m
//  InHeart
//
//  Created by 项小盆友 on 2017/6/12.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsTopCell.h"
@interface NewsTopCell ()
@end

@implementation NewsTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        _titleLabel.font = kSystemFont(16);
        _titleLabel.textColor = NAVIGATIONBAR_COLOR;
    } else {
        _titleLabel.font = kSystemFont(14);
        _titleLabel.textColor = MAIN_TEXT_COLOR;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = kSystemFont(14);
        _titleLabel.textColor = MAIN_TEXT_COLOR;
    }
    return _titleLabel;
}

@end
