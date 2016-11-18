//
//  PrescriptionContentCell.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

- (void)setupContents:(NSArray *)contentsArray;

@end
