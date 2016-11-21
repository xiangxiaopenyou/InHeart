//
//  PrescriptionContentCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PrescriptionContentCell.h"
#import "ContentCollectionCell.h"

#import "ContentModel.h"

@interface PrescriptionContentCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (copy, nonatomic) NSArray *array;

@end

@implementation PrescriptionContentCell

- (void)setupContents:(NSArray *)contentsArray {
    self.array = [contentsArray copy];
    [self.contentCollectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionView Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContentCollectionCell";
    ContentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ContentModel *tempModel = [self.array[indexPath.row] copy];
    [cell.contentsImageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.contentsNameLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 0, 15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCollectionCellItemWidth, kCollectionCellItemHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}


@end