//
//  ViewController.m
//  testCollectionView
//
//  Created by Ethank on 2017/1/10.
//  Copyright © 2017年 DY. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "dyFlowLayout.h"
#import "MHBigCollectionViewCell.h"
#import "MHSmallCollectionViewCell.h"


static NSString * const bigClass = @"MHBigCollectionViewCell";
static NSString * const smallClass = @"MHSmallCollectionViewCell";

@interface ViewController ()<dyFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionV;
@property (nonatomic, strong)NSMutableArray *mutArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
}

- (void)setUpCollectionView {
    dyFlowLayout *layout = [[dyFlowLayout alloc] init];
    layout.dy_delegate = self;
    layout.minimumLineSpacing = 1.0;
    layout.minimumInteritemSpacing = 1.0;
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    
    [self.collectionV registerClass:[MHBigCollectionViewCell class] forCellWithReuseIdentifier:bigClass];
    [self.collectionV registerClass:[MHSmallCollectionViewCell class] forCellWithReuseIdentifier:smallClass];
    
    [self.view addSubview:self.collectionV];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionV.superview);
    }];
}
- (NSMutableArray *)mutArray {
    if (!_mutArray) {
        _mutArray = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            
            if (i%3 == 0) {
                [self.mutArray addObject:@{@"type":@(1)}];
            } else {
                [self.mutArray addObject:@{@"type":@(0)}];
            }
        }
    }
    return _mutArray;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *mutDic = self.mutArray[indexPath.item];
    NSInteger type = [[mutDic objectForKey:@"type"] integerValue];
    if (type == 1) {
        MHBigCollectionViewCell *bigCell = [collectionView dequeueReusableCellWithReuseIdentifier:bigClass forIndexPath:indexPath];
        return bigCell;
    } else {
        MHSmallCollectionViewCell *smallCell = [collectionView dequeueReusableCellWithReuseIdentifier:smallClass forIndexPath:indexPath];
        return smallCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - dyFlowLayoutDelegate

- (CGSize)dyCollectionViewContentSize:(dyFlowLayout *)layout {
    __block NSUInteger smallCellCount = 0;
    __block NSUInteger bigCellCount = 0;
    [self.mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger type = [[obj objectForKey:@"type"] integerValue];
        if (type == 1) {
            bigCellCount ++;
        } else {
            smallCellCount ++;
        }
    }];
    
    CGFloat coverFlowHeight = 0;
    if (layout.dy_haveCoverFlow)
        coverFlowHeight = (kHeaderHeight+layout.minimumLineSpacing);
    
    CGSize size = CGSizeMake(self.view.frame.size.width, (ceil(smallCellCount / 2.0)*kTreasureHeight + bigCellCount*kBannerHeight + (bigCellCount + ceil(smallCellCount/2.0))*layout.minimumLineSpacing - layout.minimumLineSpacing) + coverFlowHeight);
    return size;
}

- (CGRect)dyLayout:(dyFlowLayout *)layout eachFrameForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSUInteger smallCellCount = 0;
    __block NSUInteger bigCellCount = 0;
    __block NSUInteger indexType = 0;
    [self.mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [[obj objectForKey:@"type"] integerValue];
        if (indexPath.item == idx) {
            indexType = index;
            *stop = YES;
        } else if (index == 1) {
            bigCellCount ++;
        } else {
            smallCellCount ++;
        }
    }];
    CGFloat x = 0, y = 0, w = 0, h = 0;
    if (layout.dy_haveCoverFlow) y = kHeaderHeight + layout.minimumLineSpacing;
    if (indexType == 1) {
        x = 0;
        w = kBannerWidth;
        h = kBannerHeight;
        y += ((smallCellCount/2)*kTreasureHeight + bigCellCount*kBannerHeight + (bigCellCount + smallCellCount/2)*layout.minimumLineSpacing);
    } else {
        w = kTreasureWidth;
        h = kTreasureHeight;
        if (![self isCellOnLeftBySmallCellCount:smallCellCount bigCellCount:bigCellCount]) {
            x += w + layout.minimumInteritemSpacing;
        }
        y += (smallCellCount/2)*kTreasureHeight + bigCellCount*kBannerHeight + (bigCellCount + smallCellCount/2)*layout.minimumLineSpacing;
    }
    return CGRectMake(x, y, w, h);
}

- (BOOL)isCellOnLeftBySmallCellCount:(NSUInteger)smallCellCount bigCellCount:(NSUInteger)bigCellCount {
    if ((smallCellCount + bigCellCount*2)%2 == 0) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
