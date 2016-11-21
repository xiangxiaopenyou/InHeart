//
//  UserAddressCell.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) void (^editBlock)(NSString *string);

@end
