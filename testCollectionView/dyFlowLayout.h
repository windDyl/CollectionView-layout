//
//  dyFlowLayout.h
//  testCollectionView
//
//  Created by Ethank on 2017/1/10.
//  Copyright © 2017年 DY. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat kTreasureWidth = 319.0 / 2.0;//145
static const CGFloat kTreasureHeight = 225;

static const CGFloat kBannerWidth = 320;
static const CGFloat kBannerHeight = 181.5;

static const CGFloat kHeaderWidth = 320;
static const CGFloat kHeaderHeight = 210;

@class dyFlowLayout;
@protocol dyFlowLayoutDelegate <NSObject>

- (CGRect)dyLayout:(dyFlowLayout *)layout eachFrameForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)dyCollectionViewContentSize:(dyFlowLayout *)layout;

@end

@interface dyFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak)id <dyFlowLayoutDelegate> dy_delegate;
// 是否有滚动banner
@property (assign, nonatomic) BOOL dy_haveCoverFlow;
@end
