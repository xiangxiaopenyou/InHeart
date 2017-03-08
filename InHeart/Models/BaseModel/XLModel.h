//
//  XLModel.h
//  InHeart
//
//  Created by 项小盆友 on 2017/3/8.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

#import "BaseRequest.h"

@interface XLModel : NSObject<YYModel>
+ (NSArray *)setupWithArray:(NSArray *)array;

@end
