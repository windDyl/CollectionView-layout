//
//  dyFlowLayout.m
//  testCollectionView
//
//  Created by Ethank on 2017/1/10.
//  Copyright © 2017年 DY. All rights reserved.
//

#import "dyFlowLayout.h"

@implementation dyFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    if ([self.dy_delegate respondsToSelector:@selector(dyCollectionViewContentSize:)]) {
        return [self.dy_delegate dyCollectionViewContentSize:self];
    } else {
        return CGSizeZero;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attribute.frame = CGRectMake(0, 0, kHeaderWidth, kHeaderHeight);
    }
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //修改 每个cell的attribute
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if ([self.dy_delegate respondsToSelector:@selector(dyLayout:eachFrameForItemAtIndexPath:)]) {
        attribute.frame = [self.dy_delegate dyLayout:self eachFrameForItemAtIndexPath:indexPath];
    }
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        if (self.dy_haveCoverFlow) {//有headerView
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:headerIndexPath]];
        }
        for (int j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}


@end
