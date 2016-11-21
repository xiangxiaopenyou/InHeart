//
//  UserAddressCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserAddressCell.h"

@interface UserAddressCell ()<UITextViewDelegate>

@end

@implementation UserAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.editBlock) {
        self.editBlock(textView.text);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

@end
